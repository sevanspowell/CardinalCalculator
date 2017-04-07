//
//  CalculatorBrain.swift
//  CardinalCalculator
//
//  Created by Samuel Evans-Powell on 31/3/17.
//  Copyright © 2017 Samuel Evans-Powell. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    typealias ValueAndDescriptionTuple = (value: Double, description: String)
    private var accumulator: ValueAndDescriptionTuple?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double, (String) -> (String))
        case binaryOperation((Double, Double) -> Double, (String, String) -> String)
        case equals
    }
    
    private let operations: Dictionary<String,Operation> = [
        "π"     : Operation.constant(Double.pi),
        "e"     : Operation.constant(M_E),
        
        "√"     : Operation.unaryOperation(sqrt,    { "√(\($0))" }),
        "sin"   : Operation.unaryOperation(sin,     { "sin(\($0)" }),
        "cos"   : Operation.unaryOperation(cos,     { "cos(\($0)" }),
        "±"     : Operation.unaryOperation({ -$0 }, { "-(\($0))" }),
        
        "×"     : Operation.binaryOperation({ $0 * $1 }, { "\($0) × \($1)" }),
        "÷"     : Operation.binaryOperation({ $0 / $1 }, { "\($0) ÷ \($1)" }),
        "+"     : Operation.binaryOperation({ $0 + $1 }, { "\($0) + \($1)" }),
        "−"     : Operation.binaryOperation({ $0 - $1 }, { "\($0) − \($1)" }),
        "%"     : Operation.binaryOperation({ $0.truncatingRemainder(dividingBy: $1) }, { "\($0) % \($1)" }),
        
        "="     : Operation.equals
    ]
    
    /// Performs the operation corresponding to the `symbol`;
    /// does nothing if no operation for `symbol`.
    ///
    /// - Parameter symbol: String such as "+", "*" or "√"
    ///   corresponding to a mathematical operation.
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = (value, symbol)
            case .unaryOperation(let function, let descriptionFunction):
                if accumulator != nil {
                    accumulator = (function(accumulator!.value), descriptionFunction("\(accumulator!.description)"))
                }
            case .binaryOperation(let function, let descriptionFunction):
                if accumulator != nil {
                    performPendingBinaryOperation()
                    pendingBinaryOperation = PendingBinaryOperation(function: function, descriptionFunction: descriptionFunction, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
        
    }
    
    /// Returns a Boolean value indicating whether or not a
    /// binary operation is pending.
    var resultIsPending: Bool {
        return pendingBinaryOperation != nil
    }
    
    /// Performs the pending binary operation using the calculator's
    /// accumulator as the second operand; does nothing if no pending
    /// binary operation or no acumulator.
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil // Not in middle of binary operation anymore
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    /// An operand and binary operation awaiting a second operand.
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let descriptionFunction: (String, String) -> (String)
        let firstOperand: ValueAndDescriptionTuple
        
        func perform(with secondOperand: ValueAndDescriptionTuple) -> ValueAndDescriptionTuple {
            return (function(firstOperand.value, secondOperand.value), descriptionFunction(firstOperand.description, secondOperand.description))
        }
    }
    
    /// Set the calculator's current stored operand.
    ///
    /// - Parameter operand: new operand.
    mutating func setOperand(_ operand: Double) {
        accumulator = (operand, "\(operand)")
    }
    
    /// Returns calculator's current result or accumulated result if `resultIsPending` is true.
    ///
    /// For example, if the calculator has processed "5 x 4 x", `resultIsPending` is true
    /// and `result` is "20".
    var result: Double? {
        if accumulator != nil {
            return accumulator!.value
        } else if resultIsPending {
            return pendingBinaryOperation!.firstOperand.value
        } else {
            return nil
        }
    }
    
    /// Returns a description of the sequence of operands and operations that led 
    /// to the value returned by `result` (or the result so far if 
    /// `resultIsPending`).
    var description: String? {
        if resultIsPending {
            return pendingBinaryOperation!.descriptionFunction(pendingBinaryOperation!.firstOperand.description, accumulator?.description ?? "")
        } else {
            return accumulator?.description
        }
    }
    
    /// Resets calculator back to initial state.
    mutating func reset() {
        accumulator = nil
        pendingBinaryOperation = nil
    }
}
