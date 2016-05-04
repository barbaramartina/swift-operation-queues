//
//  NSOperationExtensions.swift
//  operationqueues
//
//  Created by Barbara Rodeker on 3/9/16.
//  Copyright © 2016 Barbara M. Rodeker. All rights reserved.
//

import Foundation

// MARK: CustomDebugStringConvertible
extension NSOperation {
    
    override public var debugDescription: String {  return "Operation Name: \(name) isCancelled?: \(cancelled) isExecuting?: \(executing) isFinished?: \(finished) isReady?: \(ready) isAsynchronous?: \(asynchronous) Dependencies: \(dependencies) Priority: \(queuePriority) Quality of Services: \(qualityOfService)"
    }

}