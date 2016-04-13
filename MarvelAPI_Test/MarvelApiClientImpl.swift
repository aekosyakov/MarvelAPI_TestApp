//
//  MarvelApiClientImpl.swift
//  MarvelAPI_Test
//
//  Created by Alex Kosyakov on 12.04.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

public class MarvelApiClientImpl: NSObject {
    
    public enum ApiType {
        case Alamofire, HTTPSwift
    }
    
    private var apiType: ApiType = .Alamofire
    
    private lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .UserInteractive
        return queue
    }()
    
    init(type: ApiType) {
        self.apiType = type
    }
}

extension MarvelApiClientImpl: MarvelApiClient {
    public func requestData(method:String, params:FetchParams, completion: ((ResponseData)->())?) {
        switch apiType {
        case .Alamofire: operationQueue.addOperation(AlamofireFetchOperation(method:method, params:params, completion:completion))
        case .HTTPSwift: operationQueue.addOperation(HTTPSwiftOperation(method:method, params: params, completion: completion))
        }
    }
}