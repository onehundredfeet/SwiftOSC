//
//  Extensions.swift
//  SwiftOSC
//
//  Created by Devin Roth on 7/5/16.
//  Copyright © 2016 Devin Roth Music. All rights reserved.
//

import Foundation

extension Data {
    func toInt32() -> Int32 {
        var int = Int32()
        let buffer = UnsafeMutableBufferPointer(start: &int, count: 1)
//        let buffer = UnsafeMutableBufferPointer<Int32>.allocate(capacity: 1) // https://stackoverflow.com/questions/60869370/unsafemutablepointer-warning-with-swift-5
        _ = self.copyBytes(to: buffer)
        
        return int.byteSwapped
    }
}

extension Data {
    func toString()->String?{
        if let string = String(data: self, encoding: String.Encoding.utf8){
            return string
        } else {
            return nil
        }
    }
}

extension Date {
    //initilizes time from string "1990-01-01T00:00:00-00:00"
    init?(_ string: String){
        
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let date = RFC3339DateFormatter.date(from: string)
        
        if date == nil {
            return nil
        }
        self = date!
    }
}

extension Date {
    var oscTimetag: Timetag {
        get {
            return Timetag(Date().timeIntervalSince(Date("1900-01-01T00:00:00-00:00")!) * 0x1_0000_0000)
        }
    }
}

extension Int32 {
    func toData() -> Data {
        var int = self.bigEndian
        let buffer = UnsafeBufferPointer(start: &int, count: 1)
        return Data(buffer: buffer)
    }
}

extension UInt32 {
    func toData() -> Data {
        var int = self.bigEndian
        let buffer = UnsafeBufferPointer(start: &int, count: 1)
        return Data(buffer: buffer)
    }
}

extension Int64 {
    func toData() -> Data {
        var int = self.bigEndian
        let buffer = UnsafeBufferPointer(start: &int, count: 1)
        return Data(buffer: buffer)
    }
}
extension String {
    func toData()->Data{
        guard let resultData = self.data(using: String.Encoding.utf8) else { return self.data }
        return resultData
//        return self.data(using: String.Encoding.utf8)! // debug: TotalMix sends invalid bundle when switching servers, causing SwiftOSC to crash !
    }
    
    // add padding to string
    func toDataBase32()->Data {
        var data = self.data(using: String.Encoding.utf8)!
        var value:UInt8 = 0
        
        for _ in 1...4-data.count%4 {
            data.append(&value, count: 1)
        }
        return data
    }
    
}
extension String {
    func dataFromHexString() -> Data {
        var data = Data()
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, options: [], range: NSMakeRange(0, self.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString.withCString { strtoul($0, nil, 16) })
            data.append([num], count: 1)
        }
        
        return data
    }
    
}
extension String {
    //returns substring at the specified character index
    subscript(index: Int)->String? {
        get {
            if index > self.count - 1 || index < 0 {
                return nil
            }
            let charIndex = self.index(self.startIndex, offsetBy: index)
            let char = self[charIndex]
            
            return String(char)
        }
    }
}
extension Array {
    public subscript (safe index: UInt) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }
}
