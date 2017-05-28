//
//  ViewController.swift
//  Calculator
//
//  Created by Joe Mellin on 5/25/17.
//  Copyright © 2017 Joe Mellin. All rights reserved.
//

import UIKit
import MobileCenter
import MobileCenterAnalytics
import MobileCenterCrashes

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!

    var savedNum:Int = 0
    var currentMode:modes = .not_set
    var lastButtonWasMode:Bool = false
    var labelString:String = "0"
   
    
    
    enum modes {
        case not_set
        case addition
        case subtraction
        case multipulcation
        case division
    }
    
    @IBAction func didPressNumber(_ sender: UIButton) {
        let stringValue:String? = sender.titleLabel?.text
        
        if (lastButtonWasMode) {
            lastButtonWasMode = false
            labelString = "0"
        }
       
        labelString = labelString.appending(stringValue!)
        MSAnalytics.trackEvent("Number clicked", withProperties: ["Number" : "\(stringValue!)"])
        updateText()
    }
    
    @IBAction func mutlipleBtn(_ sender: Any) {
        changeMode(newMode: .multipulcation)
        MSAnalytics.trackEvent("Mode clicked", withProperties: ["Number" : "Multiplication"])
    }
    @IBAction func diviseBtn(_ sender: Any) {
        changeMode(newMode: .division)
        MSAnalytics.trackEvent("Mode clicked", withProperties: ["Number" : "Division"])
    }
    
    @IBAction func addBtn(_ sender: Any) {
        changeMode(newMode: .addition)
        MSAnalytics.trackEvent("Mode clicked", withProperties: ["Number" : "Addition"])
    }
    
    @IBAction func subtractBtn(_ sender: Any) {
        changeMode(newMode: .subtraction)
        MSAnalytics.trackEvent("Mode clicked", withProperties: ["Number" : "Subtraction"])
    }
    
    @IBAction func equalsBtn(_ sender: Any) {
        MSAnalytics.trackEvent("Mode clicked", withProperties: ["Number" : "Equals"])
        guard let labelInt:Int = Int(labelString) else {
            return
        }
        
        if (currentMode == .not_set || lastButtonWasMode ) {
            return
        } else {
            if (currentMode == .addition) {
                savedNum = savedNum + labelInt
            }
            else if (currentMode == .subtraction){
                savedNum -= labelInt
            }
            else if (currentMode == .multipulcation) {
                savedNum = savedNum * labelInt
            }
            else if (currentMode == .division && labelInt != 0) {
                savedNum = savedNum / labelInt
            }
                
            else if (currentMode == .division && labelInt == 0) {
                currentMode = .not_set
                savedNum = 0
                labelString = "Undefined"
                updateText()
                lastButtonWasMode = true
                return
            }
            currentMode = .not_set
            labelString = "\(savedNum)"
            updateText()
            MSAnalytics.trackEvent("Computed", withProperties: ["Answer" : "\(savedNum)"])
            lastButtonWasMode = true
        }
        
        
    }
    @IBAction func clearBtn(_ sender: Any) {
        MSAnalytics.trackEvent("Mode clicked", withProperties: ["Number" : "Clear"])
        savedNum = 0
        currentMode = .not_set
        lastButtonWasMode = false
        labelString = "0"
        label.text = "0"
    }
    
    
    
    func updateText() {
        if (labelString == "Error") {
            label.text = "Error"
        } else {
            guard let labelInt:Int = Int(labelString) else {
                return
            }
            
            if (currentMode == .not_set) {
                savedNum = labelInt
            }
            
            let formatter:NumberFormatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let num:NSNumber = NSNumber(value: labelInt)
            label.text = formatter.string(from: num)
        }
        
    }
    
    func changeMode(newMode:modes) {
        if (savedNum == 0) {
            return
        }
        currentMode = newMode
        lastButtonWasMode = true
        
        
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

