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
        displayValue = 0
        brain.setOperand(displayValue)
        descriptionValue = " "
    }
    
    @IBAction func backspace(_ sender: UIButton) {
        // Only makes sense to backspace a number if user was typing it
        if userIsInTheMiddleOfTyping {
            if let displayText = display.text {
                display.text!.remove(at: displayText.index(before:displayText.endIndex))
                // Number was fully backspaced
                if display.text!.isEmpty {
                    displayValue = 0
                    // Have to explicitly set operand on calculator in this case
                    brain.setOperand(displayValue)
                    // Required so that new numbers aren't appended to the 0, but replace it
                    userIsInTheMiddleOfTyping = false
                }
            }
        }
    }
    
    @IBOutlet weak var row0: UIStackView!
    @IBOutlet var row0CompactButtons: [UIButton]!
    @IBOutlet weak var row1: UIStackView!
    @IBOutlet var row1CompactButtons: [UIButton]!
    @IBOutlet weak var row2: UIStackView!
    @IBOutlet var row2CompactButtons: [UIButton]!
    @IBOutlet weak var row3: UIStackView!
    @IBOutlet var row3CompactButtons: [UIButton]!
    @IBOutlet weak var row4: UIStackView!
    @IBOutlet var row4CompactButtons: [UIButton]!
    
    func setupCompactUI() {
        for button in row0CompactButtons {
            button.isHidden = false
            row0.insertArrangedSubview(button, at: 0)
        }
        for button in row1CompactButtons {
            button.isHidden = false
            row1.insertArrangedSubview(button, at: 0)
        }
        for button in row2CompactButtons {
            button.isHidden = false
            row2.insertArrangedSubview(button, at: 0)
        }
        for button in row3CompactButtons {
            button.isHidden = false
            row3.insertArrangedSubview(button, at: 0)
        }
        for button in row4CompactButtons {
            button.isHidden = false
            row4.insertArrangedSubview(button, at: 0)
        }
    }
    
    func setupRegularUI() {
        for button in row0CompactButtons {
            button.isHidden = true
            row0.removeArrangedSubview(button)
        }
        for button in row1CompactButtons {
            button.isHidden = true
            row1.removeArrangedSubview(button)
        }
        for button in row2CompactButtons {
            button.isHidden = true
            row2.removeArrangedSubview(button)
        }
        for button in row3CompactButtons {
            button.isHidden = true
            row3.removeArrangedSubview(button)
        }
        for button in row4CompactButtons {
            button.isHidden = true
            row4.removeArrangedSubview(button)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass { // vertical size class has changed
            switch traitCollection.verticalSizeClass {
            case .compact:
                setupCompactUI()
            case .unspecified: fallthrough
            case .regular:
                setupRegularUI()
            }
        }
    }
}

