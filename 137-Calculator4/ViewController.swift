//
//  ViewController.swift
//  137-Calculator3
//
//  Created by Roya on 2/18/16.
//  Copyright © 2016 Roya. All rights reserved.
//  This assignment is a continuation of what professor Perry has taught us in class

import UIKit

class ViewController: UIViewController {
    
    
// label of the program aka what gets printed out on the calculator display
    @IBOutlet weak var display: UILabel!
    
    var numOfTimesCEntered = 1 // Number of times button "C" is entered is set to 1 initially
    var opo : String = ""       // opo keeps track of the current operator being entered
    var userIsInTheMiddleOfTypingANumber = false // keeps track of whether the user is typing or not
    
    var brain = CalculatorBrain() // model of this program
    
    var displayValue: Optional<Double> // the value being displayed on the calculator is converted to double(if it's an int)
        {
        get
        {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            
        }
        set
        {
            display.text = "\(newValue!)"
            userIsInTheMiddleOfTypingANumber = false
        }
        
    }
    
    // This function keeps concatenating the displayValue until the "Enter" button is entered
    
    @IBAction func appendDigit(sender: UIButton) {
        var digit = sender.currentTitle!  // the current value displayed on the calculator is stored in digit
        // this set of if/esle statements converts fraction buttons into decimals
        if (sender.currentTitle == "1/4"){
            digit = ".25"
        }
        else if (sender.currentTitle == "1/2"){
            digit = ".5"
        }
        else if (sender.currentTitle == "3/4")
        {
            digit = ".75"
        }
        else if (sender.currentTitle == "π")
        {
            digit = "3.14159"
        }
        
        if userIsInTheMiddleOfTypingANumber
        {
            display.text = display.text! + digit
        }
        else
        {
            display.text = String(digit)
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    // This function is to be entered after the user is done typing a number
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue!){ displayValue = result }
        else {displayValue = 0}
    }
    
    // This function is for all the operators
    @IBAction func operate(sender: UIButton) {
        //opo = sender.currentTitle! // opo saves the latest operator being entered
        
        opo = brain.pushOperator(sender.currentTitle!)!
        // if user is still typing an operator (using the same variable name) then keep on concatenating to the operator
        if userIsInTheMiddleOfTypingANumber
        {
            display.text = display.text! + opo
        }
            // if user is done typing an operator (determined by hitting "=")
        else
        {
            display.text = opo
            userIsInTheMiddleOfTypingANumber = true
        }
        
    }
    
    // This function clears everything except the last number in the stack if hit once
    // if hit twice (consecutively or not) it will clear the stack
    @IBAction func clear() {
        //userIsInTheMiddleOfTypingANumber = false
        
        // if "C" is entered once it will clear everything except the last number in stack
        if numOfTimesCEntered == 1{
            
            brain.clearOnce()        // clear the stack
            
            //enter()                 // keep the last number in the stack
            numOfTimesCEntered++    // increment the value to know if it's entered twice
        }
        else if numOfTimesCEntered == 2{
            numOfTimesCEntered = 1
            brain.clear()
        }
        
        // Number displayed on the calculator becomes 0 after "C" is entered
        //displayValue = 0
        display.text = nil
    }
    
    // After user is done entering as many operators as they want they should press "="
    @IBAction func equalPressed(sender: UIButton) {
        userIsInTheMiddleOfTypingANumber = false
        
        brain.displayOnCalc()
        if let result = brain.performOperation(opo)
        {
            //brain.allValues.append(String(result))
            //displayValue = result
            var word : String = ""
            
            //iterate over the array to display the operands and operators on the calculator
            for item in brain.allValues
            {
               
                if (opo == "cos" || opo == "sin" || opo == "abs" || opo == "√")
                {
                    if (brain.allValues.count == 2)
                    {
                        word = opo + "(" + brain.allValues[brain.allValues.count - 2] + ")"
                    }
                    else
                    {
                    word = opo + "(" + brain.allValues[brain.allValues.count - 1] + ")"
                    }
                    break
                }
                else
                {
                    word = word + item
                }
                //print(word)
                //print(item)
                //print(brain.allValues.count)
                //display.text = display.text! + item
                
            //display.text = String(brain.displayOnCalc()) + " = " + String(result)
        }
            brain.allValues.removeAll()
            display.text = word + " = " + String(result)
        }
        else
        {
            displayValue = 0
        }
        
    }
    
    
    // This function stores the number on display into the stack
    @IBAction func storeInMemory(sender: UIButton) {
        brain.storeMemo(displayValue!)
        
    }
    
    // This function takes the number on display and adds it to the previous number in the stack
    @IBAction func addToMemory(sender: UIButton) {
        brain.addMemo(displayValue!)
    }
    
    // This function takes the last number from the stack and display it on the calculator
    @IBAction func recallFromMemory() {
        displayValue = brain.memoRecall()
    }
    
    // This function sets the stack to 0
    @IBAction func clearMemory() {
        //brain.allValues.removeAll()
        brain.memoClear()
        //displayValue = 0.0
    }
    
    // This function displays the stack on the calculator as well as the console
    @IBAction func displayAll() {
        display.text = String(brain.displayHistory())
        print(String(brain.displayHistory()))
    }
    
    @IBAction func pressVariable(sender: UIButton) {
        let variable = String(sender.currentTitle!)
        
        
        if let result = brain.pushSymbol(String(sender.currentTitle!))
        {
            display.text = variable + " = " + String(result)
            //displayValue = result
        }
        else {display.text = variable + " = nil"}
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

