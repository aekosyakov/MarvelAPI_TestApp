/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
A convenient extension to Swift.Dictionary.
*/

public extension Dictionary {
    init<Sequence: SequenceType where Sequence.Generator.Element == Value>(sequence: Sequence, keyMapper: Value -> Key?) {
        self.init()

        for item in sequence {
            if let key = keyMapper(item) {
                self[key] = item
            }
        }
    }
}
