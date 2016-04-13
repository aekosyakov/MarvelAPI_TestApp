/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This code shows how to create a simple subclass of Operation.
*/

import Foundation

public typealias OperationBlock = (Void -> Void) -> Void

public class BlockOperation: Operation {
    private let block: OperationBlock?
	
    public init(block: OperationBlock? = nil) {
        self.block = block
        super.init()
    }
	
    convenience public init(mainQueueBlock: dispatch_block_t) {
        self.init(block: { continuation in
            dispatch_async(dispatch_get_main_queue()) {
                mainQueueBlock()
                continuation()
            }
        })
    }
    
    override public func execute() {
        guard let block = block else {
            finish()
            return
        }
        block {
            self.finish()
        }
    }
}
