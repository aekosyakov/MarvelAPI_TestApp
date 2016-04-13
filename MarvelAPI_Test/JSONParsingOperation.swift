//
//  JSONPasingOperation.swift
//  RealOktogo
//
//  Created by Andrey Kladov on 19/08/15.
//  Copyright © 2015 Andrey Kladov. All rights reserved.
//

import UIKit

public typealias JSONObject = [String: AnyObject]

public class JSONParsingOperation: Operation {
	
	public let cacheFileURL: NSURL
	public let completion: ((JSONObject?) -> Void)?
	public var parsedObject: JSONObject?
	
	public init(cacheFileURL: NSURL, completion: ((JSONObject?) -> Void)? = nil) {
		self.cacheFileURL = cacheFileURL
		self.completion = completion
		super.init()
	}
	
	override public func execute() {
		
		guard let stream = NSInputStream(URL: cacheFileURL) else {
			finish()
			return
		}
		
		stream.open()
		defer { stream.close() }
		
		do {
			parsedObject = try NSJSONSerialization.JSONObjectWithStream(stream, options: []) as? JSONObject
			completion?(parsedObject)
			finish()
		}
		catch let error as NSError {
			completion?(nil)
			finishWithError(error)
		}
	}

}
