//
//  ViewController.swift
//  OSCTest
//
//  Created by Devin Roth on 2017-11-10.
//  Copyright © 2017 Devin Roth. All rights reserved.
//

import UIKit

//import framework
import SwiftOSC

// Setup Client. Change address from localhost if needed.
var client = OSCClient(address: "localhost", port: 8080)

var address = OSCAddressPattern("/OSCTest/")

class ViewController: UIViewController {
    
    // User defaults
    private var defaults = UserDefaults.standard
    
    //Variables
    var ipAddress = "localhost"
    var port = 8080
    var text = ""
    
    var bundleTimer: Timer!
    
    // UI Elements
    @IBOutlet weak var ipAddressLabel: UITextField!
    @IBOutlet weak var portLabel: UITextField!
    @IBOutlet weak var addressPatternLabel: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Get defaults and set Labels
        if let ipAddress = defaults.string(forKey: "ipAddress") {
            
            if ipAddress == "" {
                self.ipAddress = "localhost"
            }
            ipAddressLabel.text = ipAddress
        }
        port = defaults.integer(forKey: "port")
        print(port)
        if port == 0 {
            self.port = 8080
        }
        portLabel.text = String(port)
        
        client = OSCClient(address: ipAddress, port: port)
        
//            self.bundleTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (_) in
////            var message = OSCMessage(address, 0, 0.0, true, "hello world")
////            client.send(message)
//
//             var message = OSCMessage(OSCAddressPattern("/test"), 110, 5.0, "Hello World", Blob(), true, false, nil, Timetag(1))
////            var message = OSCMessage(OSCAddressPattern("/test"), 110, 5.0, "Hello World", Blob(), true, false, nil, Timetag(1))
//            //: Create a bundle
//            // If the server fully supports timetags, like SwiftOSC, the bundle will be delivered at the correct time.
//            var bundle = OSCBundle(Timetag(secondsSinceNow: 5.0), message)
//            client.send(bundle)
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Connect UI and send OSC message
    @IBAction func ipAddressTextField(_ sender: UITextField) {
        
        if let text = sender.text {
            ipAddress = text
            client = OSCClient(address: ipAddress, port: port)
            
            defaults.set(ipAddress, forKey: "ipAddress")
        }
    }
    
    @IBAction func portTextField(_ sender: UITextField) {
        
        if let text = sender.text {
            if let number = Int(text) {
                print(number)
                port = number
                client = OSCClient(address: ipAddress, port: port)
                
                defaults.set(port, forKey: "port")
            }
        }
    }
    
    @IBAction func addressPatternTextField(_ sender: UITextField) {
        
        if let text = sender.text {
            address = OSCAddressPattern(text)
        }
    }
    
    @IBAction func stepper(_ sender: UIStepper) {
        let message = OSCMessage(address, Int(sender.value))
        client.send(message)
    }
    
    @IBAction func slider(_ sender: UISlider) {
        print(sender.value)
        let message = OSCMessage(address, sender.value)
        client.send(message)
    }
    
    @IBAction func switcher(_ sender: UISwitch) {
        let message = OSCMessage(address, sender.isOn)
        client.send(message)
        
        print("bundleTimer \(sender.isOn)")
        if sender.isOn {
//            self.bundleTimer.fire()
            self.bundleTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (_) in
//            var message = OSCMessage(address, 0, 0.0, true, "hello world")
//            client.send(message)
            
             var message = OSCMessage(OSCAddressPattern("/timedBundle"), 110, 5.0, "Hello World", Blob(), true, false, nil, Timetag(1))
//            var message = OSCMessage(OSCAddressPattern("/test"), 110, 5.0, "Hello World", Blob(), true, false, nil, Timetag(1))
            //: Create a bundle
            // If the server fully supports timetags, like SwiftOSC, the bundle will be delivered at the correct time.
            var bundle = OSCBundle(Timetag(secondsSinceNow: 5.0), message)
                print(bundle)
            client.send(bundle)
        }
        } else {
            if self.bundleTimer != nil { self.bundleTimer.invalidate() }
        }
    }
    
    @IBAction func impulse(_ sender: UIButton) {
        let message = OSCMessage(address)
        client.send(message)
    }

    @IBAction func text(_ sender: UITextField) {

        text = sender.text!
    }
    
    @IBAction func sendText(_ sender: UIButton) {
        let message = OSCMessage(address, text)
        client.send(message)
    }
    

    
}


extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
