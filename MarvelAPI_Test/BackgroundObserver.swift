/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
Contains the code related to automatic background tasks
*/

import UIKit

public class BackgroundObserver: NSObject, OperationObserver {

    private var identifier = UIBackgroundTaskInvalid
    private var isInBackground = false
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BackgroundObserver.didEnterBackground(_:)), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BackgroundObserver.didEnterForeground(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil)
        isInBackground = UIApplication.sharedApplication().applicationState == .Background
        if isInBackground {
            startBackgroundTask()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    @objc func didEnterBackground(notification: NSNotification) {
        if !isInBackground {
            isInBackground = true
            startBackgroundTask()
        }
    }
    
    @objc func didEnterForeground(notification: NSNotification) {
        if isInBackground {
            isInBackground = false
            endBackgroundTask()
        }
    }
    
    private func startBackgroundTask() {
        if identifier == UIBackgroundTaskInvalid {
            identifier = UIApplication.sharedApplication().beginBackgroundTaskWithName("BackgroundObserver", expirationHandler: {
                self.endBackgroundTask()
            })
        }
    }
    
    private func endBackgroundTask() {
        if identifier != UIBackgroundTaskInvalid {
            UIApplication.sharedApplication().endBackgroundTask(identifier)
            identifier = UIBackgroundTaskInvalid
        }
    }
    
    // MARK: Operation Observer
    
    public func operationDidStart(operation: Operation) { }
    public func operation(operation: Operation, didProduceOperation newOperation: NSOperation) { }
    public func operationDidFinish(operation: Operation, errors: [NSError]) {
        endBackgroundTask()
    }
}
