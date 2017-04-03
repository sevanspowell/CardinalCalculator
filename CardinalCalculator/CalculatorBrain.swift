//
//  CalculatorBrain.swift
//  CardinalCalculator
//
//  Created by Samuel Evans-Powell on 31/3/17.
//  Copyright © 2017 Samuel Evans-Powell. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π"     : Operation.constant(Double.pi),
        "e"     : Operation.constant(M_E),
        "√"     : Operation.unaryOperation(sqrt),
        "cos"   : Operation.unaryOperation(cos),
        "±"     : Operation.unaryOperation({ -$0 }),
        "×"     : Operation.binaryOperation({ $0 * $1 }),
        "÷"     : Operation.binaryOperation({ $0 / $1 }),
        "+"     : Operation.binaryOperation({ $0 + $1 }),
        "−"     : Operation.binaryOperation({ $0 - $1 }),
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
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
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
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    /// Set the calculator's current stored operand.
    ///
    /// - Parameter operand: new operand.
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        return accumulator
    }
}
