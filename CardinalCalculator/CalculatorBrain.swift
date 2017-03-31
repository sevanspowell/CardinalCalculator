//
//  CalculatorBrain.swift
//  CardinalCalculator
//
//  Created by Samuel Evans-Powell on 31/3/17.
//  Copyright © 2017 Samuel Evans-Powell. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    // Accumulator is optionalz
    private var accumulator: Double?
    
    mutating func performOperation(_ symbol: String) {
        switch symbol {
        case "π":
            accumulator = Double.pi
        case "√":
            if let operand = accumulator {
                accumulator = sqrt(operand)
            }
        default:
            break
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
}
