//
//  TextViewDestination.swift
//  MeMe
//
//  Created by zhang yinglong on 2017/2/23.
//  Copyright © 2017年 sip. All rights reserved.
//

import UIKit
/*
import XCGLogger

public class KeysFilter: FilterProtocol {
    static var reset:Bool = false
    
    static var key: String? {
        didSet {
            if key != oldValue {
                reset = true
            }
        }
    }
    
    public var debugDescription: String = "KeysFilter"
    
    public func shouldExclude(logDetails: inout LogDetails, message: inout String) -> Bool {
        if let key = KeysFilter.key {
            if logDetails.message.contains(key.lowercased()) {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
}

public class TextViewDestination: BaseDestination {
    
//    init() {
//        super.init()
//        filters = [KeysFilter()]
//    }
    static var MaxLength:Int = 1024*200
    static var SubLength:Int = MaxLength - 1024
    static var scrolling: Bool = false
    fileprivate var logTree: [String] = []
    fileprivate var willShowTree: [String] = []
    
    open var textView: UITextView? 
    
    // MARK: - Properties
    /// The dispatch queue to process the log on
    open var logQueue: DispatchQueue? = nil
    
    // MARK: - Overridden Methods
    /// Print the log to the console.
    ///
    /// - Parameters:
    ///     - logDetails:   The log details.
    ///     - message:   Formatted/processed message ready for output.
    ///
    /// - Returns:  Nothing
    ///
    open override func output(logDetails: LogDetails, message: String) {
        
        let outputClosure = {
            var logDetails = logDetails
            var message = message
            
            // Apply filters, if any indicate we should drop the message, we abort before doing the actual logging
//            if self.shouldExclude(logDetails: &logDetails, message: &message) {
//                return
//            }
            
            self.applyFormatters(logDetails: &logDetails, message: &message)
            
            if self.logTree.count > 1000 {
                self.logTree.removeFirst(100)
            }
            self.logTree.append(message)
            
            if(KeysFilter.reset){
                self.willShowTree.removeAll()
                self.willShowTree.insert(contentsOf:self.logTree, at: 0)
            }else{
                self.willShowTree.append(message)
            }
            if self.willShowTree.count < 5 && !KeysFilter.reset{
                return
            }
            
            if let key = KeysFilter.key, key.utf8.count > 0 {
                let pre: NSPredicate = NSPredicate(format: "self contains [cd] %@", key)
                let result = (self.willShowTree as NSArray).filtered(using: pre)
                self.willShowTree = result as! [String]
            } else {
            }

            var text = ""
            for item in self.willShowTree {
                text.append(item)
                text.append("\n")
            }
            self.willShowTree.removeAll()
            
            if let textView = self.textView {
                if SystemUtil.cpuUsage() < 90 && !TextViewDestination.scrolling {
                    main_async({
                        if(KeysFilter.reset){
                            KeysFilter.reset = false
                            textView.text.removeAll()
                        }
                        if let msg = textView.text , msg.count > TextViewDestination.MaxLength{
                            let start = msg.startIndex
                            let index = msg.index(msg.endIndex, offsetBy: -TextViewDestination.SubLength)
                            let range = start..<index
                            textView.text.removeSubrange(range)
                        }
                        textView.text.append(text)
//                        let distanceFromBottom = textView.contentSize.height - textView.contentOffset.y
//                        if (distanceFromBottom < textView.height) {
//                            textView.scrollRangeToVisible(NSRange(location: textView.text.utf8.count, length: 1))
//                        }
                    })
                }
            } else {
                self.logTree.removeAll()
                print(message)
            }
        }
        
        if let logQueue = logQueue {
            logQueue.async(execute: outputClosure)
        }
        else {
            outputClosure()
        }
    }

}
*/
