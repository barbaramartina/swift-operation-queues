//
//  BASED ON: ConcurrentOperation.swift
//
//  Created by Caleb Davenport on 7/7/14.
//  
//  From Apple Docs:
//  If you are creating a concurrent operation, you need to override the following methods and properties at a minimum:
//  start
//  asynchronous
//  executing
//  finished
//
//  https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSOperation_class/#//apple_ref/occ/instp/NSOperation/ready
//
//  Notes from Apple Docs:
//  When you call the start method of an asynchronous operation, that method may return before the corresponding task is completed. An asynchronous operation object is responsible for scheduling its task on a separate thread. The operation could do that by starting a new thread directly, by calling an asynchronous method, or by submitting a block to a dispatch queue for execution. It does not actually matter if the operation is ongoing when control returns to the caller, only that it could be ongoing.
// 
//  When you add an operation to an operation queue, the queue ignores the value of the asynchronous property and always calls the start method from a separate thread. Therefore, if you always run operations by adding them to an operation queue, there is no reason to make them asynchronous.
//
//
//  Learn more at http://blog.calebd.me/swift-concurrent-operations
//

import Foundation

public class MyAsynchronousOperation: NSOperation {
    
    // NOTE: any other property must be thread safe. If using constant, there won't be any problem, bc Swift ensure constants are initialized only once.
    // From Apple Docs:  When you subclass NSOperation, you must make sure that any overridden methods remain safe to call from multiple threads. If you implement custom methods in your subclass, such as custom data accessors, you must also make sure those methods are thread-safe. Thus, access to any data variables in the operation must be synchronized to prevent potential data corruption. For more information about synchronization, see Threading Programming Guide.
    // https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSOperation_class/#//apple_ref/c/tdef/NSOperationQueuePriority READ: Multicore Considerations
    
    // MARK: - Types
    
    enum State {
        case Ready, Executing, Finished
        func keyPath() -> String {
            switch self {
            case Ready:
                return "isReady"
            case Executing:
                return "isExecuting"
            case Finished:
                return "isFinished"
            }
        }
    }
    
    // MARK: - Properties
    
    var state = State.Ready {
        willSet {
            willChangeValueForKey(newValue.keyPath())
            willChangeValueForKey(state.keyPath())
        }
        didSet {
            didChangeValueForKey(oldValue.keyPath())
            didChangeValueForKey(state.keyPath())
        }
    }

    // From Apple Docs:
    // At no time in your start method should you ever call super. When you define a concurrent operation, you take it upon yourself to provide the same behavior that the default start method provides, which includes starting the task and generating the appropriate KVO notifications. Your start method should also check to see if the operation itself was cancelled before actually starting the task. For more information about cancellation semantics, see Responding to the Cancel Command. 
    //
    override public func start() {
        if (self.cancelled) {
            self.state = .Finished // not that here we also are saying that executing value is 'false' 
            // Specifically, if you manage the values for the finished and executing properties yourself (perhaps because you are implementing a concurrent operation), you must update those properties accordingly. Specifically, you must change the value returned by finished to true and the value returned by executing to false. You must make these changes even if the operation was cancelled before it started executing.
            // https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSOperation_class/#//apple_ref/doc/uid/TP40004591-RH2-SW18 Read: Responding to the Cancel Command
            
        } else {
            
            // IMPLEMENT YOUR ASYNCH CODE HERE
            // IN EXAMPLE:
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), { [weak self] in
                
                // https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSOperationQueue_class/
                //Canceling an operation object leaves the object in the queue but notifies the object that it should abort its task as quickly as possible. For currently executing operations, this means that the operation object’s work code must check the cancellation state, stop what it is doing, and mark itself as finished.
                if self!.cancelled {
                    self!.state = .Finished
                    return
                }
                
                print("Hello Susana")
                self!.state = .Finished
                })
            
            
            // if operation is cancelled or finished after processing your logic you should update the state:
            // From Apple Docs: If you replace the start method or your operation object, you must also replace the finished property and generate KVO notifications when the operation finishes executing or is cancelled.
            
            self.state = .Executing;
            
            // if operation is cancelled or finished after processing your logic you should update the state:
            // From Apple Docs: If you replace the start method or your operation object, you must also replace the finished property and generate KVO notifications when the operation finishes executing or is cancelled.
        }
    }
    
    // MARK: - NSOperation
    
    override public var ready: Bool {
        return super.ready && state == .Ready
    }
    
    override public var executing: Bool {
        return state == .Executing
    }
    
    override public var finished: Bool {
        return state == .Finished
    }
    
    override public var asynchronous: Bool {
        return true
    }
    
}