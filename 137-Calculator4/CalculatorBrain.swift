//
//  CalculatorBrain.swift
//  137-Calculator3
//
//  Created by Roya on 2/18/16.
//  Copyright © 2016 Roya. All rights reserved.
//  This program is a continuation of what professor Perry has taught us in class

import Foundation
class CalculatorBrain
{
    // enum stores all the operators and operands
    private enum Op: CustomStringConvertible
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String
            {
            get
            {
                switch self
                {
                case .Operand(let operand): return "\(operand)"
                case .UnaryOperation(let symbol, _): return symbol
                case .BinaryOperation(let symbol, _): return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String: Op]()
    
    private var operators : [String] = []     // an array of String to keep track of the operators if needed
    private var operands : [Double] = []    // an array of Double to keep track of operands for M functions (e.g. M+)
    var variableValues: Dictionary <String, Double> = [String: Double]()
    
    var allValues : [String] = []

    
    
    // all the operators on the calculator
    init()
    {
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["%"] = Op.UnaryOperation("%") {$0 / 100.0}
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["sin"] = Op.UnaryOperation("sin") {sin($0)}
        knownOps["cos"] = Op.UnaryOperation("cos") {cos($0)}
        knownOps["abs"] = Op.UnaryOperation("abs") {abs($0)}
        knownOps["z"] = Op.UnaryOperation("z") {$0}


        
    }
    
    // Evaluate the operation based on whether it's unary or binary
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
                
            case .Operand(let operand):
                return (operand, remainingOps)
                
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result
                {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
                
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result
                {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result
                    {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double?
    {
        let (result, remainder) = evaluate(opStack)
        operands.append(result!) // added by roya
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    //new function
    func pushSymbol(symbol: String) -> Double?
    {
        variableValues[symbol] = operands.last
    
        
        if (variableValues[symbol] != nil)
        {
            print(variableValues)
            print("\(symbol): \(variableValues[symbol])")
            return evaluate()
        }
        
        else{
            return nil
        }
            

        //return evaluate()
    }
    
    

    func pushOperand(operand: Double) -> Double?
    {
        //operands.append(operand)                // add the operand to operands array
        opStack.append(Op.Operand(operand))     //add the operand to the enum
        return evaluate()
    }
    
    // This function gets the operator being entered and adds it to the operate array
    func pushOperator(opo: String) -> String?
    {
        operators.append(opo)
        
        return opo
    }
    
    func performOperation(symbol: String) -> Double?
    {
        
        if let operation = knownOps[symbol] {
            opStack.append(operation)
            //operators.append(symbol)
            //print("fine")
        }

        operators.removeAll()
        operands.removeAll()
        return evaluate()
    }
    
    // This function completely clear out the stack
    func clear()
    {
        opStack = [Op]()
        print("\(opStack)")

        //evaluate()
    }
    
    func clearOnce()
    {
        let lastNum = operands.removeLast()
        allValues.removeAll()
        operands.removeAll()
        operators.removeAll()
        
        opStack.removeAll()     // Clears out the stack
        opStack.append(Op.Operand(lastNum))      // replaces the empty stack with 0
        evaluate()
    }
    
    func storeMemo(operand: Double)
    {
        opStack.append(Op.Operand(operand))
        //operands.append(operand)
    }
    
    func addMemo(operand: Double)
    {
        let lastOperand = operands.last
        opStack.append(Op.Operand(lastOperand! + operand))
    }
    
    func memoClear()
    {
        allValues.removeAll()
        operands.removeAll()
        operators.removeAll()
        
        opStack.removeAll()     // Clears out the stack
        opStack.append(Op.Operand(0))      // replaces the empty stack with 0
    }
    
    // This function gets the last number in the operands array and returns it to be displayed on the calculator
    func memoRecall () -> Double{
        let lastNumber = operands.last
        return lastNumber!
    }
    
    // This function returns an array of string to be displayed on the calculator and on the console
    func displayOnCalc() -> [String] {
        //print(operands)
        //print(operators)
        
        for item in operands
        {
            allValues.append(String(item))
            //print(item)
            
            for item in operators
            {
                allValues.append(String(item))
                //print(item)
            }
        }
        if (operands.count == 3)
        {
            allValues.removeFirst()
            allValues.removeFirst()
        }
        if(operands.count == 1)
        {
            allValues.append("?")
        }
        //print(allValues)
        allValues.removeLast()
        return allValues
    }
    
    func displayHistory() -> [String] {
        
         for item in opStack{
          allValues.append(String(item))
        }
        return allValues
    }
}

