/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
A convenient extension to Foundation.NSOperation.
*/

import Foundation

public extension NSOperation {
    func addCompletionBlock(block: Void -> Void) {
        if let existing = completionBlock {
            completionBlock = {
                existing()
                block()
            }
        } else {
            completionBlock = block
        }
    }

    func addDependencies(dependencies: [NSOperation]) {
        for dependency in dependencies {
            addDependency(dependency)
        }
    }
}
