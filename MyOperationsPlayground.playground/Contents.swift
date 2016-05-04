//: Playground - noun: a place where people can play

import UIKit
import Foundation


// ************************************************************
// ************************************************************
// ************************************************************




let observer = SillyObserver()

let syncOp = MySynchronousOperation()
observer.observeOperation(syncOp)
syncOp.name = "SYNC operation"

let asyncOp = MyAsynchronousOperation()
observer.observeOperation(asyncOp)
asyncOp.name = "ASYNC operation"

let queue = NSOperationQueue()
queue.name = "exampleQueue"
queue.maxConcurrentOperationCount = 4
queue.qualityOfService = .UserInteractive

queue.addOperation(syncOp)
queue.addOperation(asyncOp)



// ************************************************************
// ************************************************************
// ************************************************************
