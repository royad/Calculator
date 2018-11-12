//
//  CalculatorBrain.swift
//  137-Calculator3
//
//  Created by Roya on 2/18/16.
//  Copyright © 2016 Roya. All rights reserved.
//

import Foundation
class CalculatorBrain
{
    
    internal enum Op: CustomStringConvertible
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
    
    private var operate : [String] = []
    private var operands : [Double] = []
    
    init()
    {
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["%"] = Op.BinaryOperation("%") { $1 / 100.0 }
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
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
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double?
    {
        operands.append(operand) // added by roya
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    //added by roya
    func pushOperator(opo: String) -> String?
    {
        operate.append(opo)
        return opo
    }
    
    func performOperation(symbol: String) -> Double?
    {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
            operate.append(symbol) // added by roya
        }
        return evaluate()
    }
    
    func clear()
    {
        opStack = [Op]()
        evaluate()
    }
    
    func MS(operand: Double)
    {
        opStack.append(Op.Operand(operand))
        //operands.append(operand)
    }
    
    func addM(operand: Double)
    {
        let lastV = operands.last
        //let temp = Double(String(opStack.last))
        //print (temp)
        //let number = temp! + operand
       // opStack.append(Op.Operand(2.0))
        opStack.append(Op.Operand(lastV! + operand))
    }
    
    func memoClear()
        
    {
        opStack.removeAll()
        opStack.append(Op.Operand(0))
        //double checking if it sets the memo to zero
    }
    
    func memoRecall () ->Double{
        let lastNumber = operands.last
        return lastNumber!
    }
    
    func displayOnCalc(){
        
        //for opo in operate{
           // return
        }
    }

