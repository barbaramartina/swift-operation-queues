//
//  An Observer class intended to show how KVO works on operations and queues
//
//  Created by Barbara Rodeker on 3/3/16.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//

import Foundation

class SimpleObserver: NSObject {
    
    // You can get more information about the operation observing any of the following paths.
    // https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSOperation_class/#//apple_ref/doc/uid/TP40004591-RH2-SW25
    // cancelled / executing / finished / concurrent / asynchronous / ready / name
    func observeOperation(op: NSOperation) {
        op.addObserver(self, forKeyPath: "executing", options: .New, context: nil)
        op.addObserver(self, forKeyPath: "cancelled", options: .New, context: nil)
        op.addObserver(self, forKeyPath: "finished", options: .New, context: nil)
        op.addObserver(self, forKeyPath: "concurrent", options: .New, context: nil)
        op.addObserver(self, forKeyPath: "asynchronous", options: .New, context: nil)
        op.addObserver(self, forKeyPath: "ready", options: .New, context: nil)
        op.addObserver(self, forKeyPath: "name", options: .New, context: nil)
    }
    
    // These are the KVO compliant properties of a queue.
    // https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSOperationQueue_class/#//apple_ref/doc/uid/TP40004592-RH2-SW19 Read: KVO-Compliant Properties
    func observeQueue(queue: NSOperationQueue) {
        queue.addObserver(self, forKeyPath: "operations", options: .New, context: nil)
        queue.addObserver(self, forKeyPath: "operationCount", options: .New, context: nil)
        queue.addObserver(self, forKeyPath: "maxConcurrentOperationCount", options: .New, context: nil)
        queue.addObserver(self, forKeyPath: "suspended", options: .New, context: nil)
        queue.addObserver(self, forKeyPath: "name", options: .New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
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
}