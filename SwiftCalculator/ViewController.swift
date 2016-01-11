//
//  ViewController.swift
//  SwiftCalculator
//
//  Created by Sean Regular on 12/21/15.
//  Copyright © 2015 CS193p. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var outputLog: UILabel!
    
    var userInMiddleOfTypingANumber: Bool = false
    var operandStack = Array<Double>()
    var displayValue: Double {
        get { return NSNumberFormatter().numberFromString(display.text!)!.doubleValue }
        set {
            display.text = "\(newValue)"
            userInMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func clear() {
        userInMiddleOfTypingANumber = false
        displayValue = 0
        operandStack.removeAll()
        outputLog.text = ""
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if (userInMiddleOfTypingANumber) {
            display.text = display.text! + digit
        }
        else {
            display.text = digit
            userInMiddleOfTypingANumber = true
        }
        outputLog.text = outputLog.text! + digit
    }
    
    @IBAction func appendDecimal() {
        if (userInMiddleOfTypingANumber) {
            if display.text!.containsString(".") == false {
                display.text = display.text! + "."
            }
        }
        else {
            display.text = "0."
            userInMiddleOfTypingANumber = true
        }
        outputLog.text = outputLog.text! + "."
    }
 
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userInMiddleOfTypingANumber {
            enter()
        }
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        default: break
        }
        outputLog.text = outputLog.text! + " " + operation + " = " + display.text! + "\n"
    }
    
    @IBAction func pi_button() {
        if userInMiddleOfTypingANumber {
            enter()
        }
        outputLog.text = outputLog.text! + "∏"
        displayValue = M_PI
        enter()
    }
    
    @IBAction func enter() {
        userInMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        outputLog.text = outputLog.text! + " "
        print("operandStack = \(operandStack)")
    }
    
    // Operation with one arguments
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    // Operation with two arguments
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(),
                operandStack.removeLast())
            enter()
        }
    }

}

