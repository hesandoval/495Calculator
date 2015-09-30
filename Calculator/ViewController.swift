//
//  ViewController.swift
//  Calculator
//
//  Created by Hector Sandoval on 9/15/15.
//  Copyright (c) 2015 Hector Sandoval. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var display: UILabel!
    var typingNumber = false
    var validDecimal = true
    var brain = CalculatorBrain()

    var displayValue: Double? {
        get{
            if let text = display.text{
               return NSNumberFormatter().numberFromString(text)!.doubleValue
            }else{
                return nil
            }
            
        }
        set{
            if let value = newValue{
                display.text = "\(value)"
            }
            else{
                display.text = "ERR"
            }
            typingNumber = false
        }
    }
    var historyDisplay: String?{
        get{
            if let text = history.text{
                return text
            }
            return " "
        }
        set{
            if let value = newValue{
               history.text = value == " " ? value : value + "="
            }
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        //print("digit = \(digit)")
        if typingNumber{
            display.text = display.text! + digit
        }else{
            display.text = digit
            typingNumber = true
        }
        
    }
    @IBAction func addDecimal() {
        if validDecimal{
            display.text = display.text! + "."
        }
        typingNumber = true
        validDecimal = false
    }
    @IBAction func enter() {
        typingNumber = false
        validDecimal = true
        if let result =  brain.pushOperand(displayValue!){
            displayValue = result
        }else{
            displayValue = nil
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if typingNumber{
            enter()
        }
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation){
                displayValue = result
            }
            else{
                displayValue = nil
            }
            if let historyVal = brain.brainContents{
                historyDisplay = historyVal
            }
        }
    }
    @IBAction func pushVariable() {
        if let result = brain.pushOperand("M"){
            displayValue = result
        }
    }
    @IBAction func setVariable() {
        if let value = displayValue{
            if let result = brain.setVar(value){
                displayValue = result
            }
            if let historyVal = brain.brainContents{
                historyDisplay = historyVal
            }
            typingNumber = false
        }
    }
    @IBAction func clear() {
        displayValue = 0
        historyDisplay = " "
        brain.clearVariables()
    }

    
}

