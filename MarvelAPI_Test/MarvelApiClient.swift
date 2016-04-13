//
//  MarvelApiClient.swift
//  MarvelAPI_Test
//
//  Created by Alex Kosyakov on 12.04.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//
import Foundation

public typealias ResponseData = (data: AnyObject? , error: NSError?)
public typealias FetchParams  = [String : AnyObject]?

public enum HTTPMethod: String {
    case GET  = "GET"
    case POST = "POST"
}

public protocol MarvelApiClient {
    func requestData(method:String, params:FetchParams, completion: ((ResponseData)->())?)
}

