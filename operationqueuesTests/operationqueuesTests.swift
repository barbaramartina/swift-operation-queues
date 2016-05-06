//
//  operationqueuesTests.swift
//  operationqueuesTests
//
//  Created by Barbara Rodeker on 3/3/16.
//  Copyright © 2016 Barbara M. Rodeker. All rights reserved.
//

import XCTest
@testable import operationqueues

class operationqueuesTests: XCTestCase {
    
    var syncOperation1: MySynchronousOperation?
    var syncOperation2: MySynchronousOperation?
    
    var asyncOperation1: MyAsynchronousOperation?
    var asyncOperation2: MyAsynchronousOperation?

    var queue1: NSOperationQueue?
    var queue2: NSOperationQueue?
    
    var observer: SimpleObserver?
    
    override func setUp() {
        super.setUp()

        syncOperation1 = MySynchronousOperation()
        syncOperation2 = MySynchronousOperation()
        asyncOperation1 = MyAsynchronousOperation()
        asyncOperation2 = MyAsynchronousOperation()

        queue1 = NSOperationQueue()
        queue1?.name = "unit.test.queue-1"
        queue2 = NSOperationQueue()
        queue2?.name = "unit.test.queue-2"
        
        observer = SimpleObserver()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
     This test print the default initial values associated with a synchronous operation
     */
    func testDefaultInitialValuesSYNCOperation() {
        printOperation(syncOperation1!)
        XCTAssertNotNil(syncOperation1)
    }

    /**
     This test print the default initial values associated with a asynchronous operation
     */
    func testDefaultInitialValuesASYNCOperation() {
        printOperation(asyncOperation1!)
        XCTAssertNotNil(asyncOperation1)
    }
    
    /**
     Enqueue an asynchronous operation in a queue.
     We can debug here and see that the effect is the same as scheduling a synch operation.
     Queues always execute the ops on a different thread.
    */
    func testAsynchSingleOperationInQueue() {
        let expectation = expectationWithDescription("Asynch operation execution should finish")
        
        asyncOperation1?.completionBlock = { [weak asyncOperation1] in
            if (asyncOperation1!.finished && !asyncOperation1!.cancelled) {
                expectation.fulfill()
            }
        }
        
        queue1?.addOperation(asyncOperation1!)
        
        waitForExpectationsWithTimeout(10.0) { error in
            if let e = error {
                XCTFail("Operation did not finish \(e)")
            } else {
                XCTAssertTrue(true)
            }
        }
    }
    
    /**
     Schedule 2 operations on a queue with max concurrency set to 2.
     This is a simple test to check both are run on separate threads.
     */
    func test2OperationsMaxConcurrency2() {
        let expectation1 = expectationWithDescription("Asynch operation 1 execution should finish")
        let expectation2 = expectationWithDescription("Asynch operation 2 execution should finish")
        
        queue1?.maxConcurrentOperationCount = 2
        
        asyncOperation1?.completionBlock = { [weak asyncOperation1] in
            if (asyncOperation1!.finished && !asyncOperation1!.cancelled) {
                expectation1.fulfill()
            }
        }

        asyncOperation2?.completionBlock = { [weak asyncOperation2] in
            if (asyncOperation2!.finished && !asyncOperation2!.cancelled) {
                expectation2.fulfill()
            }
        }

        queue1?.addOperations([asyncOperation1!, asyncOperation2!], waitUntilFinished: false)
        
        waitForExpectationsWithTimeout(10.0) { error in
            if let e = error {
                XCTFail("Operation did not finish \(e)")
            } else {
                XCTAssertTrue(true)
            }
        }
    }
    
    /**
     Here we should see no more than 3 operations are running concurrently at the same time
     */
    func testMaxConcurrency3AndSeveralOpsScheduled() {
        //TODO
    }
    
    /**
     Here we should observe only 1 operation is executed in a particular moment
     */
    func testMaxConcurrency1AndSeveralOpsScheduled() {
    }

    func testPerformanceExample() {
        self.measureBlock {
            //TODO complete
        }
    }
    
    // MARK: private
    
    func printOperation(op: NSOperation) {
        print("Operation Name: \(op.name)")
        print(" isCancelled?: \(op.cancelled)")
        print(" isExecuting?: \(op.executing)")
        print(" isFinished?: \(op.finished)")
        print(" isReady?: \(op.ready)")
        print(" isAsynchronous?: \(op.asynchronous)")
        print(" Dependencies: \(op.dependencies)")
        print(" Priority: \(op.queuePriority)")
        print(" Quality of Services: \(op.qualityOfService)")
    }
    
}

