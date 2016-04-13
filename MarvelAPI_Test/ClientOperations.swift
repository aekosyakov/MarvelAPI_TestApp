//
//  ClientOperation.swift
//  MarvelAPI_Test
//
//  Created by Alex Kosyakov on 12.04.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftHTTP


// MARK: Alamofire
class AlamofireFetchOperation: RequestOperation {
    override func execute() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            guard let completionHandler = self.completion else { return }
            Alamofire.request(.GET, self.method, parameters: self.params).responseJSON { (response) -> Void in
                guard let jsonResponse = response.result.value as? JSONObject where response.result.error == nil else {
                    completionHandler((nil, response.result.error))
                    return
                }
                //print("jsonResponse \(jsonResponse)")
                completionHandler((jsonResponse, nil))
            }
        })
    }
}

// MARK: HTTPSwift
class HTTPSwiftOperation: RequestOperation {
    override func execute() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            guard let completionHandler = self.completion else { return }
            
            do {
                let opt = try HTTP.GET(self.method, parameters: self.params)
                opt.start { response in
                    if let err = response.error {
                        completionHandler((nil, err))
                        return
                    }
                }
            } catch let error {
                completionHandler((nil, NSError(domain: "", code: 0, userInfo:["message" : "\(error)"])))
            }
        })
        
    }
}


// MARK: Base
class RequestOperation: Operation {
    var method: String
    var params: FetchParams
    var completion:((ResponseData) -> ())?
    
    init(
        method methodName:String,
               params fetchParams:FetchParams,
                      completion handler: ((ResponseData)->())?
        ) {
        method = methodName
        completion = handler
        params = fetchParams
        super.init()
    }
}