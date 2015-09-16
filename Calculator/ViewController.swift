//
//  ViewController.swift
//  Calculator
//
//  Created by Hector Sandoval on 9/15/15.
//  Copyright (c) 2015 Hector Sandoval. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var historyDisplay: UILabel!
    @IBOutlet weak var display: UILabel!
    var typingNumber = false
    var validDecimal = true
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        println("digit = \(digit)")
        if typingNumber{
            if digit == "."{
                if validDecimal{
                    display.text = display.text! + digit
                    validDecimal = false
                }
            }else{
                display.text = display.text! + digit
            }
            
        }else{
            display.text = digit
            if digit == "."{
                validDecimal = false
            }
            typingNumber = true
        }
        
    }
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        typingNumber = false
        validDecimal = true
        historyDisplay.text = historyDisplay.text! + " \(displayValue) "
        operandStack.append(displayValue)
        println("Operand Stack = \(operandStack)")
        
    }
    

    var displayValue: Double {
        get{
           return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            typingNumber = false
        }
    }
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if typingNumber{
            enter()
        }
        historyDisplay.text = historyDisplay.text! + " \(operation) "
        switch operation{
        case "×":performOperation {$0 * $1}
        case "÷":performOperation {$1 / $0}
        case "+":performOperation {$0 + $1}
        case "-":performOperation {$1 - $0}
        case "√":perform { sqrt($0) }
        case "sin": perform { sin($0) }
        case "cos":perform { cos($0) }
        case "π": piAction()
        default: break
            
        }
    }
    func piAction() {
        display.text = "\(M_PI)"
    }
    
    func perform(operation: Double->Double ){
        if operandStack.count >= 1{
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: (Double, Double)->Double ){
        if operandStack.count >= 2{
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    @IBAction func clear() {
        display.text = ""
        historyDisplay.text = ""
        operandStack = Array<Double>()
    }

    
}

