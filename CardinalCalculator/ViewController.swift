//
//  ViewController.swift
//  CardinalCalculator
//
//  Created by Samuel Evans-Powell on 30/3/17.
//  Copyright © 2017 Samuel Evans-Powell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel! // Optional because may not be set (e.g. during startup before label is created) - implicity unwrapped optional
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
            // Append touched digit to display
            let textCurrentlyInDisplay = display.text!
            let proposedText = textCurrentlyInDisplay + digit
            
            if Double(proposedText) != nil { // Prevent invalid input
                display.text = proposedText
            }
        } else {
            // Set display to touched digit
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)! // Assume text label is always a double
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain : CalculatorBrain = CalculatorBrain()

    @IBAction func performOperation(_ sender: UIButton) {
        if (userIsInTheMiddleOfTyping) {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        print(brain.description ?? "empty")
    }
    
    @IBAction func clear(_ sender: UIButton) {
        brain.reset()
        if userIsInTheMiddleOfTyping {
            userIsInTheMiddleOfTyping = false
        }
        displayValue = 0.0

        print(brain.description ?? "empty")
    }
    
}

