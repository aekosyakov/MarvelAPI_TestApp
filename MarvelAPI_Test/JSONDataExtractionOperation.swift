//
//  ResponseDataExtractionOperation.swift
//  TravelruSDK
//
//  Created by Andrey Kladov on 03/09/15.
//  Copyright © 2015 Andrey Kladov. All rights reserved.
//

import Foundation

public class JSONDataExtractionOperation<T: Any>: Operation {

	let object: JSONObject?
	let completion: (T?, NSError?) -> Void
	
	init(object: JSONObject?, expectedResponseType: T.Type, completion c: (T?, NSError?) -> Void) {
		self.object = object
		completion = c
		super.init()
	}
	
	override public func execute() {
		switch ((object?["error"] as? JSONObject)?["message"] as? String, object?["data"] as? T) {
		case (.Some(let message), _):
			let error = produceErrorWithMessage(message)
			completion(nil, error)
			finishWithError(produceErrorWithMessage(message))
		case (_, .Some(let data)):
			completion(data, nil)
			finish()
		default:
            if (object?.keys.contains("data") != nil) {  // if response goes without "data" key
                if let data = object as? T {
                    completion(data, nil)
                    finish()
                }
            } else {
                let error = produceErrorWithMessage(NSLocalizedString("Something went wrong", comment: ""))
                completion(nil, error)
                finishWithError(error)
            }
		}
	}
	
	private func produceErrorWithMessage(message: String) -> NSError {
		return NSError(code: .ExecutionFailed, userInfo: [NSLocalizedDescriptionKey: message])
	}
	
}

