//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Hector Sandoval on 9/28/15.
//  Copyright © 2015 Hector Sandoval. All rights reserved.
//

import Foundation

class CalculatorBrain{
//private***********************************************************************
    private enum Op: CustomStringConvertible{
        case Operand(Double)
        case UnaryOperation(String, Double->Double)
        case BinaryOperation(String, (Double,Double)->Double);
        case Variable(String)
        
        var description: String{
            get{
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .Variable(let variable):
                    return "\(variable)"
                }
            }
        }
    }
    

//******************************************************************************
    private func evaluate(ops: [Op])->(result: Double?, remainingOps:[Op]){
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return (operand, remainingOps)
            case .Variable(let variable):
                print(variable)
                if let variableValue = variableValues[variable]{
                    return (variableValue, remainingOps)
                }
            case .UnaryOperation(_,let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return(operation(operand), operandEvaluation.remainingOps)
                }
                
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }

            }
        }
        return (nil, ops)
    }

    private func brainContentHelper(ops: [Op]) -> (result: String?, remainingOps:[Op]){
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return("\(operand)", remainingOps)
            case .Variable(let variable):
                if let val = variableValues[variable]{
                    return("\(val)", remainingOps)
                }else{
                    return ("M", remainingOps)
                }
                
                
            case .UnaryOperation(let operation, _):
                let unaryOperandHelper = brainContentHelper(remainingOps)
                if let operand = unaryOperandHelper.result{
                    return (operation+"(\(operand))", unaryOperandHelper.remainingOps)
                }
            case .BinaryOperation(let operation, _):
                let binaryOperand1 = brainContentHelper(remainingOps)
                if let operand1 = binaryOperand1.result{
                    let binaryOperand2 = brainContentHelper(binaryOperand1.remainingOps)
                    if let operand2 = binaryOperand2.result{
                        return("("+operand2 + " " + operation + " " + operand1+")"
                            , binaryOperand2.remainingOps)
                    }
                }
            }
            
        }
        return (nil, ops)
    }
    private var opStack = [Op]()
    private var knownOps = [String: Op]();
    private var variableValues = [String: Double]()
    
    
//public************************************************************************
    
    init(){
        func learnOp(op: Op){
            knownOps[op.description] = op
        }
        learnOp(Op.UnaryOperation("π",  {$0 * M_PI}))
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷"){$1 / $0})
        learnOp(Op.BinaryOperation("-"){$1 - $0})
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
    }
    
    
    
    var brainContents: String?{
        get{
            if let result = brainContentHelper(opStack).result{
                return result
            }
            return nil
        }
    }
    
    
    func pushOperand(operand:Double) ->Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    func pushOperand(operand:String)->Double?{
        opStack.append(Op.Variable(operand))
        return evaluate()
    }
    func performOperation(symbol: String)->Double?{
        //knownOps[symbol]
        //whenever you look up something in a dictionary it comes back as
        //an optional
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    func setVar(value: Double)->Double?{
        variableValues["M"] = value
        return evaluate()
    }
    func evaluate() ->Double?{
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    func clearVariables(){
        variableValues = [String: Double]()
    }

}
