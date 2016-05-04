//
//  MySynchronousOperation.swift
//  operationqueues
//
//  Created by Barbara Rodeker on 3/3/16.
//  Copyright © 2016 Barbara M. Rodeker. All rights reserved.
//

import Foundation

public class MySynchronousOperation: NSOperation {


    public override func main() {
        if self.cancelled {
            return
        }
        
        // do some processing

        // cancelled should be checked periodically
        // From Apple Documentation: In particular, your main task code should periodically check the value of the cancelled property. If the property reports the value true, your operation object should clean up and exit as quickly as possible
        // https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSOperation_class/#//apple_ref/doc/uid/TP40004591-RH2-SW18
        
        if self.cancelled {
            return
        }
        
        // do more processing
    }
}
