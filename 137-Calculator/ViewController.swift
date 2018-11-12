//
//  ViewController.swift
//  137-Calculator
//
//  Created by Roya on 2/17/16.
//  Copyright © 2016 Roya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
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

    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber{ enter() }
        if let operation = sender.currentTitle
        {
            if let result = brain.performOperation(operation) {displayValue = result}
            else {displayValue = 0}
        }
    }
    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        brain.clear()
        displayValue = 0
    }
    
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue){ displayValue = result }
        else {displayValue = 0}
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

