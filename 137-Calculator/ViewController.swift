//
//  ViewController.swift
//  137-Calculator3
//
//  Created by Roya on 2/18/16.
//  Copyright © 2016 Roya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var display: UILabel!
    
    var n = 1
    var opo : String = ""
    var userIsInTheMiddleOfTypingANumber = false
    var brain = CalculatorBrain()
    var displayValue: Double
        {
        get
        {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        
        set
        {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
        
    }
    
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber
        {
            display.text = display.text! + digit
        }
        else
        {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }

    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue){ displayValue = result }
        //else if let result = brain.performOperation(opo) {display.text = opo}
    else {displayValue = 0}
    }
    
    @IBAction func operate(sender: UIButton) {
        //added by roya
        opo = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber
        {
            display.text = display.text! + opo
        }
        else
        {
            display.text = opo
            userIsInTheMiddleOfTypingANumber = true
        }
        //done adding
        /*if userIsInTheMiddleOfTypingANumber{ enter() }
        if let operation = sender.currentTitle
        {
            if let result = brain.performOperation(operation) {displayValue = result}
            else {displayValue = 0}
        }*/
        
    }
    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
    
        if n == 1{
            brain.clear()
            enter()
            n++
        }
        else if n == 2{
            n = 1
            brain.clear()
        }
        
        displayValue = 0
    }
    
    @IBAction func equalPressed(sender: UIButton) {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.performOperation(opo) {displayValue = result}
        else {displayValue = 0}

    }
    
    
    @IBAction func storeInMemory(sender: UIButton) {
        brain.MS(displayValue)
        
    }
    
    
    @IBAction func addToMemory(sender: UIButton) {
        brain.addM(displayValue)
    }
    
    @IBAction func recallFromMemory() {
        displayValue = brain.memoRecall()
    }
   
    @IBAction func clearMemory() {
        brain.memoClear()
    }
    
    
    @IBAction func displayAll() {
        brain.displayOnCalc()
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

