import Foundation
import PlaygroundSupport
/*:

# SwiftOSC 
A simple OSC Client and Server for Swift 3.0
 
 */
//: ## Quick Start - Server
//: ### Step 1
//: Import SwiftOSC
import SwiftOSC

//: ### Step 2
//: Create Server
var server = OSCServer(address: "", port: 8080)

//: ### Step 3
//: Create Server
server.start()

//: ### Step 4
//: Handle notifications from Server
NotificationCenter.default.addObserver(forName: OSCServer.didReceiveMessage, object: nil, queue: nil, using:
    { (notification: Notification) in
        let message = notification.object as! OSCMessage
        print(message)
    }
)
//: ## Quick Start - Client
//: ### Step 1
//: Import SwiftOSC
import SwiftOSC

//: ### Step 2
//: Create client
var client = OSCClient(address: "localhost", port: 8080)

//: ### Step 3
//: Create a message
var message = OSCMessage(OSCAddressPattern("/"), 100, 5.0, "Hello World", Blob(), true, false, nil, impulse, Timetag(1))

//: ### Step 4
//: Send message
client.send(message)

//:Keeps playground running in order to send and receive OSC Data
PlaygroundPage.current.needsIndefiniteExecution = true
