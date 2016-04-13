/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This file contains the foundational subclass of NSOperation.
*/

import Foundation

public class Operation: NSOperation {
	
    class func keyPathsForValuesAffectingIsReady() -> Set<NSObject> { return ["state"] }
    class func keyPathsForValuesAffectingIsExecuting() -> Set<NSObject> { return ["state"] }
    class func keyPathsForValuesAffectingIsFinished() -> Set<NSObject> { return ["state"] }
    class func keyPathsForValuesAffectingIsCancelled() -> Set<NSObject> { return ["state"] }
    
    // MARK: State Management
    
    private enum State: Int, Comparable {
        case Initialized
        case Pending
        case EvaluatingConditions
        case Ready
        case Executing
        case Finishing
        case Finished
        case Cancelled
    }
	
    public func willEnqueue() {
        state = .Pending
    }
	
    private var _state = State.Initialized

    private var state: State {
        get {
            return _state
        }
    
        set(newState) {
            willChangeValueForKey("state")
            switch (_state, newState) {
			case (.Cancelled, _): ()
			case (.Finished, _): ()
			case (let old, let new) where old == new: print("Performing invalid cyclic state transition.")
			default: _state = newState
            }
            didChangeValueForKey("state")
        }
    }
	
    override public var ready: Bool {
        switch state {
            case .Pending:
                if super.ready {
                    evaluateConditions()
                }
                return false
            case .Ready: return super.ready
            default: return false
        }
    }
    
    public var userInitiated: Bool {
        get { return qualityOfService == .UserInitiated }
        set {
            assert(state < .Executing, "Cannot modify userInitiated after execution has begun.")
            qualityOfService = newValue ? .UserInitiated : .Default
        }
    }
    
    override public var executing: Bool {
        return state == .Executing
    }
    
    override public var finished: Bool {
        return state == .Finished
    }
    
    override public var cancelled: Bool {
        return state == .Cancelled
    }
    
    private func evaluateConditions() {
        assert(state == .Pending, "evaluateConditions() was called out-of-order")

        state = .EvaluatingConditions
        
        OperationConditionEvaluator.evaluate(conditions, operation: self) { failures in
            if failures.isEmpty {
                self.state = .Ready
            } else {
                self.state = .Cancelled
                self.finish(failures)
            }
        }
    }
    
    // MARK: Observers and Conditions
    
    private(set) var conditions = [OperationCondition]()

    public func addCondition(condition: OperationCondition) {
        assert(state < .EvaluatingConditions, "Cannot modify conditions after execution has begun.")
        conditions.append(condition)
    }
    
    private(set) var observers = [OperationObserver]()
    
    public func addObserver(observer: OperationObserver) {
        assert(state < .Executing, "Cannot modify observers after execution has begun.")
        observers.append(observer)
    }
    
    override public func addDependency(operation: NSOperation) {
        assert(state <= .Executing, "Dependencies cannot be modified after execution has begun.")
        super.addDependency(operation)
    }
    
    // MARK: Execution and Cancellation
    
    override final public func start() {
        assert(state == .Ready, "This operation must be performed on an operation queue.")
        state = .Executing
        for observer in observers {
            observer.operationDidStart(self)
        }
        
        execute()
    }
	
    public func execute() {
        print("\(self.dynamicType) must override `execute()`.")
        finish()
    }
    
    private var _internalErrors = [NSError]()
    override public func cancel() {
        cancelWithError()
    }
    
    public func cancelWithError(error: NSError? = nil) {
        if let error = error {
            _internalErrors.append(error)
        }
        
        state = .Cancelled
    }
    
    final public func produceOperation(operation: NSOperation) {
        for observer in observers {
            observer.operation(self, didProduceOperation: operation)
        }
    }
    
    // MARK: Finishing
    
    final public func finishWithError(error: NSError?) {
        if let error = error {
            finish([error])
        } else {
            finish()
        }
    }
	
    private var hasFinishedAlready = false
    final public func finish(errors: [NSError] = []) {
        if !hasFinishedAlready {
            hasFinishedAlready = true
            state = .Finishing
            
            let combinedErrors = _internalErrors + errors
            finished(combinedErrors)
            
            for observer in observers {
                observer.operationDidFinish(self, errors: combinedErrors)
            }
            
            state = .Finished
        }
    }
	
    public func finished(errors: [NSError]) { }
    
    override public func waitUntilFinished() {
        fatalError("Waiting on operations is an anti-pattern. Remove this ONLY if you're absolutely sure there is No Other Way™.")
    }
	
	deinit { print("\(self) deinit") }
    
}

private func <(lhs: Operation.State, rhs: Operation.State) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

private func ==(lhs: Operation.State, rhs: Operation.State) -> Bool {
    return lhs.rawValue == rhs.rawValue
}
