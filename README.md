# Operation Queues in Swift

A project to show how operations (both asynch and synch) can be implemented in [Swift](https://swift.org/).  
With links to concrete **Apple** documentation included in the code for quick references.  

## Operations

[NSOperation](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSOperation_class/index.html#//apple_ref/doc/uid/TP40004591-RH2-SW18) allows to encapsulate related logic to perform a task. This class is provided in Apple Foundation framework, and you just have different ways to use it:  
1. Subclassing and implementing: **async** and **sync** operations.  
2. Use one of the system defined subclasses: [NSInvocationOperation](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSInvocationOperation_Class/index.html#//apple_ref/occ/cl/NSInvocationOperation) or [NSBlockOperation](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSBlockOperation_class/index.html#//apple_ref/occ/cl/NSBlockOperation).  


<p align=center>
<img src="https://github.com/barbaramartina/swift-operation-queues/blob/master/resources/1%20-%20operations.png" width=500/>
</p>

## Queues  

[NSOperationQueue](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSOperationQueue_class/) is the container class in charge of handling operations, sending them to be executed, prioritazing the execution order, handling the threads to which every operation is assigned or using [GCD](https://developer.apple.com/library/ios/documentation/Performance/Reference/GCD_libdispatch_Ref/).  


## Operation dependencies  

One of the advantage, apart from encapsulation and reusability, is the possibility to establish dependencies between operations, so you can express when one operation should wait for one or more operations to finish.  

Suppose you want to consume an image from a public service and upload it later to a personal server, maybe after doing some custom changes on it, then you'd have two operations:  
  
  
1. Download. 
2. Upload.  

With established dependency as follows:  

<p align=center>
<img src="https://github.com/barbaramartina/swift-operation-queues/blob/master/resources/2%20-%20dependencies.png" width=450>
</p>  

## Operations: synchronous and asynchronous  

**If you do not use queues** to schedule your operations, and decide to execute operations manually (not recommended), in this case, an operation could run:  

1. On the same thread they are called. (**synchronous**).  
2. On a different thread. (**asynchronous**).  

<p align=center>
<img src="https://github.com/barbaramartina/swift-operation-queues/blob/master/resources/2.1%20-%20async%20and%20sync%20ops.png" width=350>
</p>

Checkout ["Asynchronous Versus Synchronous Operations"](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSOperation_class) on the NSOperation docs.  



> :exclamation: When you add an operation to an operation queue, the queue ignores the value of the asynchronous property and always calls the start method from a separate thread. Therefore, if you always run operations by adding them to an operation queue, there is no reason to make them asynchronous.




