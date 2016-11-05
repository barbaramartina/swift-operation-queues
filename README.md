# Operation Queues in Swift
## This repo is based in Swift 2.3 many changes have been added to Swift 3 and a simplified and beautiful sintax is in place now to be used for Operations and GCD.

A project to show how operations (both asynch and synch) can be implemented in [Swift](https://swift.org/).  
With links to concrete **Apple** documentation included in the code for quick references.  


## Operations

[NSOperation](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSOperation_class/index.html#//apple_ref/doc/uid/TP40004591-RH2-SW18) allows to encapsulate related logic to perform a task. This class is provided in Apple Foundation framework, and you have these ways to use it:  
1. Subclassing and implementing: **async** and **sync** operations.  
2. Use one of the system defined subclasses: [NSInvocationOperation](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSInvocationOperation_Class/index.html#//apple_ref/occ/cl/NSInvocationOperation) or [NSBlockOperation](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSBlockOperation_class/index.html#//apple_ref/occ/cl/NSBlockOperation).  


<p align=center>
<img src="https://github.com/barbaramartina/swift-operation-queues/blob/master/resources/1%20-%20operations.png" width=500/>
</p>

## Queues  

[NSOperationQueue](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSOperationQueue_class/) is the container class in charge of handling operations, sending them to be executed, prioritizing the execution order, handling the threads to which every operation is assigned or using [GCD](https://developer.apple.com/library/ios/documentation/Performance/Reference/GCD_libdispatch_Ref/).  


## Operation dependencies  

One of the advantage, apart from encapsulation and reusability, is the possibility to establish dependencies between operations, so you can express when one operation should wait for one or more operations to finish.  

Suppose you want to consume an image from a public service and upload it later to a personal server, maybe after doing some custom changes on it, then you'd have two operations:  
  
  
1. Download. 
2. Upload.  

With established dependency as follows:  

<p align=center>
<img src="https://github.com/barbaramartina/swift-operation-queues/blob/master/resources/2%20-%20dependencies.png" width=450>
</p>  

### Dependencies on multiple queues

Dependencies will be respected, even if your operations are in different queues.  

<p align=center>
<img src="https://github.com/barbaramartina/swift-operation-queues/blob/master/resources/4%20-%20dependencies%20and%20multiple%20queues.png" width=350>
</p>

## Operations: synchronous and asynchronous  

**If you do not use queues** to schedule your operations, and decide to execute operations manually (not recommended), in this case, an operation could run:  

1. On the same thread they are called. (**synchronous**).  
2. On a different thread. (**asynchronous**).  

<p align=center>
<img src="https://github.com/barbaramartina/swift-operation-queues/blob/master/resources/2.1%20-%20async%20and%20sync%20ops.png" width=450>
</p>

Checkout ["Asynchronous Versus Synchronous Operations"](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSOperation_class) on the NSOperation docs.  



> :exclamation: When you add an operation to an operation queue, the queue ignores the value of the asynchronous property and always calls the start method from a separate thread. Therefore, if you always run operations by adding them to an operation queue, there is no reason to make them asynchronous.


### Synchronous (non-concurrent) operation subclasses

Checkout the implementation of `MySynchronousOperation`.  
You need to implement the `main` method. 

    override func main() {
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
    
> :exclamation: Since NSOperation is thread safe, make sure any getter and setter you implement is also thread safe.  

### Asynchronous (concurrent) operations subclasses 

In this case you need to override `start`, `asynchronous`, `executing` and `finished`. 
Checkout `MyAsynchronousOperation`.  

> :exclamation:  You also need to generate the appropiate KVO notifications. Checkout [subclassing notes](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSOperation_class).  


## Operation states  

An operation could be in any of the following states.  

<p align=center>
<img src="https://github.com/barbaramartina/swift-operation-queues/blob/master/resources/6%20-%20operation%20states.png" width=500>
</p>  

[Check how to get operation status in Apple Docs.](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSOperation_class/#//apple_ref/doc/uid/TP40004591-RH2-SW25)  


> :exclamation: **Finished** can mean it was executed completely or it was cancelled.  

## Operation cancellation

You can cancel an operation when it's in the queue, or when it's executing.  
Do not believe it will be automatically stopped, because calling cancel has some other implications.  

[Checkout cancellation documentation for more details.](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSOperation_class/#//apple_ref/doc/uid/TP40004591-RH2-SW24)  


## Cancelling when it's waiting in the queue  

<p align=center>
<img src="https://github.com/barbaramartina/swift-operation-queues/blob/master/resources/7%20-%20cancellation%20while%20in%20the%20queue.png" width=500>
</p>  

## Cancelling when it's executing  

<p align=center>
<img src="https://github.com/barbaramartina/swift-operation-queues/blob/master/resources/8%20-%20cancellation%20while%20executing.png" width=500>
</p>


## KVO on queues and operations  

You can observe the following properties:  

<p align=center>
<img src="https://github.com/barbaramartina/swift-operation-queues/blob/master/resources/9%20-%20KVO%20on%20ops%20and%20queues.png" width=500>
</p>  

Associating your observer class as follows:  

    func observeOperation(op: NSOperation) {
        op.addObserver(self, forKeyPath: "executing", options: .New, context: nil)
        op.addObserver(self, forKeyPath: "cancelled", options: .New, context: nil)
        op.addObserver(self, forKeyPath: "finished", options: .New, context: nil)
        op.addObserver(self, forKeyPath: "concurrent", options: .New, context: nil)
        op.addObserver(self, forKeyPath: "asynchronous", options: .New, context: nil)
        op.addObserver(self, forKeyPath: "ready", options: .New, context: nil)
        op.addObserver(self, forKeyPath: "name", options: .New, context: nil)
    }

    func observeQueue(queue: NSOperationQueue) {
        queue.addObserver(self, forKeyPath: "operations", options: .New, context: nil)
        queue.addObserver(self, forKeyPath: "operationCount", options: .New, context: nil)
        queue.addObserver(self, forKeyPath: "maxConcurrentOperationCount", options: .New, context: nil)
        queue.addObserver(self, forKeyPath: "suspended", options: .New, context: nil)
        queue.addObserver(self, forKeyPath: "name", options: .New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, 
      change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        let key = keyPath!
        switch key {
        case "executing", "cancelled", "finished", "concurrent", "asynchronous", "ready", "name":
            print("operation information: \(key) - \((object?.description) ?? "")")
        case "operations", "operationCount", "maxConcurrentOperationCount", "suspended", "name":
            print("queue information: \(key) - \((object?.description) ?? "")")
        default:
            return
        }
    }
    

## Quality of service

Defines the priority with which an operation will access system resources, once running.  
- A queue can have qualityOfService.  
- An operation can have quealityOfService too.  
- The operation quality of service has priority over the queue qos.  
- The queue qos will be apply as default to all the operations that do not have an explicit value.  

<p align=center>
<img src="https://github.com/barbaramartina/swift-operation-queues/blob/master/resources/10%20-%20qualityOfService%20on%20queues.png" width=500>
</p>  


