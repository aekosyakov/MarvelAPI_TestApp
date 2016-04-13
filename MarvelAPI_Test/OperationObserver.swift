/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file defines the OperationObserver protocol.
*/

import Foundation

public protocol OperationObserver {
    func operationDidStart(operation: Operation)
    func operation(operation: Operation, didProduceOperation newOperation: NSOperation)
    func operationDidFinish(operation: Operation, errors: [NSError])
}
