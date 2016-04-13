/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file shows how operations can be composed together to form new operations.
*/

import Foundation

public class GroupOperation: Operation {
	
    private let internalQueue = OperationQueue()
    private let finishingOperation = NSBlockOperation(block: {})

    private var aggregatedErrors = [NSError]()
    
    convenience init(operations: NSOperation...) {
        self.init(operations: operations)
    }
    
    init(operations: [NSOperation]) {
        super.init()
        internalQueue.suspended = true
        internalQueue.delegate = self
        for operation in operations {
            internalQueue.addOperation(operation)
        }
    }
    
    override public func cancel() {
        internalQueue.cancelAllOperations()
        super.cancel()
    }
    
    override public func execute() {
        internalQueue.suspended = false
        internalQueue.addOperation(finishingOperation)
    }
    
    func addOperation(operation: NSOperation) {
        internalQueue.addOperation(operation)
    }
	
    final func aggregateError(error: NSError) {
        aggregatedErrors.append(error)
    }
    
    func operationDidFinish(operation: NSOperation, withErrors errors: [NSError]) { }
}

extension GroupOperation: OperationQueueDelegate {
    final public func operationQueue(operationQueue: OperationQueue, willAddOperation operation: NSOperation) {
        assert(!finishingOperation.finished && !finishingOperation.executing, "cannot add new operations to a group after the group has completed")
		
        if operation !== finishingOperation {
            finishingOperation.addDependency(operation)
        }
    }
    
    final public func operationQueue(operationQueue: OperationQueue, operationDidFinish operation: NSOperation, withErrors errors: [NSError]) {
        aggregatedErrors.appendContentsOf(errors)
        
        if operation === finishingOperation {
            internalQueue.suspended = true
            finish(aggregatedErrors)
        } else {
            operationDidFinish(operation, withErrors: errors)
        }
    }
}
