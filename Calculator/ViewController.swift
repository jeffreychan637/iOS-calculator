//
//  ViewController.swift
//  Calculator
//
//  Created by Jeffrey Chan on 5/27/15.
//  Copyright (c) 2015 Jeffrey Chan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //defining a class called ViewController inheriting from UIVIewController
    
    @IBOutlet weak var display: UILabel!  //display is a pointer to our label in the heap
    //this is an instance variable in our class
    //UI Lable refers to the type of our variable
    //UILabel is an Optional and thus is automaticall initialized to nil.
    //When the app is run, display is set very early for us and the explanation point is added so that display is always unwrapped for us - thus it's an "implicitly unwrapped Optional"

    var userTypingNumber: Bool = false
    //In Swift, when classes are initialized, all properties (instance variables) must have been initialized
    //var is true when user is in the middle of typing a number
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        //let is a declaration for a constant variable in Swift
        //don't have to declare type for digit - Swift is very good at inferring variable types
        //currentTitle property has type Optional. Optionals have two states - they are either set or not set (nil). When they're set they are set to a variable of a specific type - in this case String.
        //By adding the explanation point, we upwrap the value from the Optional object. If currentTitle was nil and we tried to get the value out of it, our app will crash.
        if userTypingNumber {
            display.text = display.text! + digit
            //display.text is a Optional whose value is a string. We're setting it to a new string here.
        } else {
            display.text = digit
            userTypingNumber = true
        }
        //println("digit = \(digit)")
        //Swift converts everything in \() into a string and displays it
        
    }
    
    @IBAction func operate(sender: UIButton) {
        if userTypingNumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0 //lame
            }
        }
        
//        switch operation {
//            case "÷": //we're passing in a function here
//                performOperation( { (op1: Double, op2: Double) -> Double in //note keyword in
//                    return op2 / op1
//                } )
//        case "×": performOperation({ (op1, op2) in return op1 * op2})
//                //swift can do type interference - since it knows you're calling performOperation, it can infer the types for the function being passed in!
//        case "−": performOperation({ (op1, op2) in op2 - op1})
//                //swift knows that the function being passed in returns a double so since our function is one statement, we don't even need the return keyword
//        case "+": performOperation() { $0 + $1 }
//                //swift by default names the arguments $0, $1, etc. This means we don't need to refer to them as op1 and op2. This further means we can just remove the argument definitions altogether and just have the function contents.
//                //also since we're passing in a function as the LAST (and only in this case) argument into Perform operation, we can actually move it outside of the parentheses. If there were other args to performOperation, we can put them inside the parentheses.
//                //ACTUALLY, SINCE THERE ARE NO OTHER ARGS, WE CAN JUST GET RID OF THE PARENTHESES ALTOGETHER IF WE WANTED TO LEAVING performOperation { $0 + $1 }
//        case "√": performOperationSingle { sqrt($0) }
//            default: break
//        }
        //All these switch statements mean the same things, but they get more and more simplified as we take advantage of features of Swift
    }
    
    //operation is of type function that takes in two doubles as arguments and returns a double
//    func performOperation(operation: (Double, Double) -> Double) {
//        if operandStack.count >= 2 {
//            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
//            enter()
//        }
//    }
//    
//    func performOperationSingle(operation: Double -> Double) {
//        if operandStack.count >= 1 {
//            displayValue = operation(operandStack.removeLast())
//            enter()
//        }
//    }
    
//    var operandStack = Array<Double>()
    //don't need to specify type since Swift can infer it - actually considered bad form to put the type - if it can be inferred, then let it be.
    
    @IBAction func enter() {
        userTypingNumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0 //lame - want display value to be nil - would be better if display value was optional
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            //set includes a magic variable called newValue that represents the value it's going to be set to
            display.text = "\(newValue)"
            userTypingNumber = false
        }
    }
    //instead of setting displayValue to a specific value, we're calculating it each time with the get function.
    
}

