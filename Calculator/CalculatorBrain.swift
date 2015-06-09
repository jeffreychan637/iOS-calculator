//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jeffrey Chan on 6/4/15.
//  Copyright (c) 2015 Jeffrey Chan. All rights reserved.
//

import Foundation
//no UI stuff - models should never have UI stuff!

class CalculatorBrain {
    
    //Printable is a protocol. We're telling Swift here that this enum, class, etc. implements this protocol (in this case, a computed property called description that returns a string
    //This has nothing to do with inheritance - remember than enums don't have inheritance!
    private enum Op: Printable {
        case Operand(Double) //swift unlike other languages allows you to associate data types with cases - here, we're saying that Operand is of type Double
        case Symbol(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                    case .Operand(let operand):
                        return "\(operand)"
                    case .Symbol(let symbol):
                        return "\(symbol)"
                    case .UnaryOperation(let symbol, _):
                        return symbol
                    case .BinaryOperation(let symbol, _):
                        return symbol
                }
            }
        }// Enums only allow for computed properties (read-only)
    }
    //API = application program interface - description of your class and all the methods in it
    
    private var opStack = [Op]() //same as Array<Op>() - shorthand is more preferred
    
    private var knownOps = Dictionary<String, Op>() //AKA [String : Op]()
    
    private var knownSyms = [String: Op]()
    
    //by default variables are public within your application
    //Can use keyword private to make things private within your class
    //Can use keyword public to make things public outside of your application (e.g. when making a framework for others)
    
    //Initializer for Calculator Brain
    init() {
        func learnOp(op: Op) { //can have functions inside of functions!
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *)) //using built-in operations
        knownOps["÷"] = Op.BinaryOperation("÷", { $1 / $0 })
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 } //can just put it outside parentheses
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["cos"] = Op.UnaryOperation("cos", cos)
        knownOps["sin"] = Op.UnaryOperation("sin", sin)
        
        
        knownSyms["π"] = Op.Symbol(M_PI)
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) { //can name return values if you want to
        if !ops.isEmpty {
            //let op = ops.removeLast() <- not allowed because ops is immutable
            //ops is immutable because when anything but classes are passed into an function, they're passed in with an implicit "let" (e.g. let ops = argument value) so all passed in values are immutable
            //could solve this by putting var before argument (e.g. var ops: [Ops]) but that's kind of confusing for code readers.
            //In Swift, arrays, dicts, double, ints are structs - only differences between classes and structs are that structs can't have inheritance and are pass by value while classes are pass by reference
            //instead we make a new variable and this makes a COPY of the array that we can mutate.
            //Swift is smart though. Doesn't actually make copy of things until you change one of them (or might not even do that - just keeps track of changes sometimes).
            //Could pass by reference through some in/out syntax where you don't make copies at all (Look that up yourself)
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op { //switch statements are hella useful in enums - allows us to get out the correct value
                case .Operand(let operand): //adds the . because we're technically doing op.Operand
                //the let statement basically says create a constant variable operand that equals the double in op
                    return (operand, remainingOps)
                case .Symbol(let symbol):
                    return (symbol, remainingOps)
                case .UnaryOperation(_, let operation): //underbar in Swift basically means I don't care so we're ignoring the symbol in this case because we don't need it.
                    let operandEvaluation = evaluate(remainingOps)
                    if let operand = operandEvaluation.result {
                        return (operation(operand), operandEvaluation.remainingOps)
                    }
                case .BinaryOperation(_, let operation):
                    let op1Evaluation = evaluate(remainingOps)
                    if let operand1 = op1Evaluation.result {
                        let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                        if let operand2 = op2Evaluation.result {
                            return (operation(operand1, operand2), op2Evaluation.remainingOps)
                        }
                    }
                //don't need default: break because we handled all possible values of Op
                
            }
            
            
        }
        return (nil, ops)
    }
    
    func evalulate() -> Double? { //returning Optional because we want to return nil if someone makes an error (e.g. asking us to evaulate + without any given operands
        let (result, remainder) = evaluate(opStack) //another way to get multiple return values; variable names don't have to match return value names from function
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evalulate()
    }
    
    func pushMathSymbolOperand(symbol: String) -> Double? {
        if let value = knownSyms[symbol] {
            opStack.append(value)
        }
        return evalulate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol]  {//operation is an Optional because if symbol not in dictionary, then we must return nil
            opStack.append(operation)
        }
        return evalulate()
    }
    
    
}