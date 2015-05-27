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
    
    var operandStack: Array<Double> = Array<Double>()
    
    @IBAction func enter() {
        userTypingNumber = false
        
    }
    
}

