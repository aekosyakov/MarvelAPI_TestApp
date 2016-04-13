/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
Contains the code to manage the visibility of the network activity indicator
*/

import UIKit

public struct NetworkObserver: OperationObserver {

    public init() { }
    
    public func operationDidStart(operation: Operation) {
        dispatch_async(dispatch_get_main_queue()) {
            NetworkIndicatorController.sharedIndicatorController.networkActivityDidStart()
        }
    }
    
    public func operation(operation: Operation, didProduceOperation newOperation: NSOperation) { }
	
	public func operationDidFinish(operation: Operation, errors: [NSError]) {
        dispatch_async(dispatch_get_main_queue()) {
            NetworkIndicatorController.sharedIndicatorController.networkActivityDidEnd()
        }
    }
    
}

private class NetworkIndicatorController {

    static let sharedIndicatorController = NetworkIndicatorController()

    private var activityCount = 0
    private var visibilityTimer: Timer?
    
    // MARK: Methods
    
    func networkActivityDidStart() {
        assert(NSThread.isMainThread(), "Altering network activity indicator state can only be done on the main thread.")
        activityCount += 1
        updateIndicatorVisibility()
    }
    
    func networkActivityDidEnd() {
        assert(NSThread.isMainThread(), "Altering network activity indicator state can only be done on the main thread.")
        activityCount -= 1
        updateIndicatorVisibility()
    }
    
    private func updateIndicatorVisibility() {
        if activityCount > 0 {
            showIndicator()
		} else {
			visibilityTimer = Timer(interval: 1.0) {
				self.hideIndicator()
			}
		}
    }
	
    private func showIndicator() {
        visibilityTimer?.cancel()
        visibilityTimer = nil
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    private func hideIndicator() {
        visibilityTimer?.cancel()
        visibilityTimer = nil
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

class Timer {

    private var isCancelled = false
    
    // MARK: Initialization

    init(interval: NSTimeInterval, handler: dispatch_block_t) {
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(interval * Double(NSEC_PER_SEC)))
        
        dispatch_after(when, dispatch_get_main_queue()) { [weak self] in
            if self?.isCancelled != .Some(true) {
				handler()
            }
        }
    }
    
    func cancel() {
        isCancelled = true
    }
}