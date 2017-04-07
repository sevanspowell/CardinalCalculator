//
//  ViewController.swift
//  CardinalCalculator
//
//  Created by Samuel Evans-Powell on 30/3/17.
//  Copyright © 2017 Samuel Evans-Powell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var descriptionDisplay: UILabel!
    
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
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumFractionDigits = 6
            numberFormatter.minimumFractionDigits = 0
            numberFormatter.minimumIntegerDigits = 1
            
            display.text = numberFormatter.string(from: newValue as NSNumber)
        }
    }
    
    var descriptionValue: String {
        get {
            return descriptionDisplay.text ?? " "
        }
        set {
            var newDescription = newValue
            
            if newValue != " " {
                newDescription += brain.resultIsPending ? "..." : " ="
            }
            
            descriptionDisplay.text = newDescription
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
            descriptionValue = brain.description ?? " "
        }
    }
    
    @IBAction func clear(_ sender: UIButton) {
        brain.reset()
        if userIsInTheMiddleOfTyping {
            userIsInTheMiddleOfTyping = false
        }
        displayValue = 0.0
        descriptionValue = " "
    }
    
    @IBAction func backspace(_ sender: UIButton) {
        // Only makes sense to backspace a number if user was typing it
        if userIsInTheMiddleOfTyping {
            if let displayText = display.text {
                display.text!.remove(at: displayText.index(before:displayText.endIndex))
                if display.text!.isEmpty {
                    display.text = "0"
                    userIsInTheMiddleOfTyping = false
                }
            }
        }
    }
}

