//
//  MySynchronousOperation.swift
//  operationqueues
//
//  Created by Barbara Rodeker on 3/3/16.
//  Copyright © 2016 Barbara M. Rodeker. All rights reserved.
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

import Foundation

class MySynchronousOperation: NSOperation {


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
}
