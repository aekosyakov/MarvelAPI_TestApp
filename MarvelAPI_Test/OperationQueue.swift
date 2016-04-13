/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file contains an NSOperationQueue subclass.
*/

import Foundation

@objc public protocol OperationQueueDelegate: NSObjectProtocol {
    optional func operationQueue(operationQueue: OperationQueue, willAddOperation operation: NSOperation)
    optional func operationQueue(operationQueue: OperationQueue, operationDidFinish operation: NSOperation, withErrors errors: [NSError])
}

public class OperationQueue: NSOperationQueue {
    weak var delegate: OperationQueueDelegate?
    
    override public func addOperation(operation: NSOperation) {
        if let op = operation as? Operation {
            let delegate = BlockObserver(
                startHandler: nil,
                produceHandler: { [weak self] in
                    self?.addOperation($1)
                },
                finishHandler: { [weak self] in
                    if let q = self {
                        q.delegate?.operationQueue?(q, operationDidFinish: $0, withErrors: $1)
                    }
                }
            )
            op.addObserver(delegate)
			
            let dependencies = op.conditions.flatMap { $0.dependencyForOperation(op) }
                
            for dependency in dependencies {
                op.addDependency(dependency)
                self.addOperation(dependency)
            }
			
            let concurrencyCategories: [String] = op.conditions.flatMap { condition in
                if !condition.dynamicType.isMutuallyExclusive { return nil }
                return "\(condition.dynamicType)"
            }

            if !concurrencyCategories.isEmpty {
                let exclusivityController = ExclusivityController.sharedExclusivityController
                exclusivityController.addOperation(op, categories: concurrencyCategories)
                op.addObserver(BlockObserver { operation, _ in
                    exclusivityController.removeOperation(operation, categories: concurrencyCategories)
                })
            }
			
            op.willEnqueue()
        } else {
            operation.addCompletionBlock { [weak self, weak operation] in
                guard let queue = self, let operation = operation else { return }
                queue.delegate?.operationQueue?(queue, operationDidFinish: operation, withErrors: [])
            }
        }
        
        delegate?.operationQueue?(self, willAddOperation: operation)
        super.addOperation(operation)   
    }
    
    override public func addOperations(operations: [NSOperation], waitUntilFinished wait: Bool) {
        for operation in operations {
            addOperation(operation)
        }
        
        if wait {
            for operation in operations {
              operation.waitUntilFinished()
            }
        }
    }
	
	deinit { print("\(self) deinit") }
}
