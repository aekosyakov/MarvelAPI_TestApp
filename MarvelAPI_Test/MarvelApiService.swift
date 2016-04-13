//
//  MarvelApiService.swift
//  MarvelAPI_Test
//
//  Created by Alex Kosyakov on 12.04.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import Foundation

protocol MarvelApiService {
    var apiClient: MarvelApiClient { get set }
    var parser:    Parser          { get set }
    init(apiClient: MarvelApiClient, parser: Parser)
    
    func loadCharactersList(count:Int?, offset:Int?, completion: ((NSError?)->())?)
    func loadCharacterDetails(characterID:Int, completion: ((NSError?)->())?)
    func loadCharactersSubsection(sectionID:Int, subsection:MarvelSection, completion: ((NSError?)->())?)
}

public typealias SectionData  = (section: MarvelSection, details: MarvelSectionType)

protocol MarvelURLConstructor {
    static func configureURLString(apiDomain:MarvelDomainConsts, section: MarvelSection) -> String
}

public struct MarvelAPIConsts {
    static let PublicKey  = "e7fb3f64e0511c07600d94692e8c7d22"
    static let PrivateKey = "97f0dd519027560a97961190bee5d2a45e65b9e8"
}

public enum MarvelDomainConsts: String {
    case  Marvel    = "marvel.com/public/v1"
    case  Developer = "http://developer.marvel.com/public/v1"
    case  Gateaway  = "http://gateway.marvel.com:80/v1/public"
    
    public var urlValue: String {
        return self.rawValue;
    }
}

public enum MarvelSection: String {
    case Characters   = "/characters"
    case Comics       = "/comics"
    case Events       = "/events"
    case Series       = "/series"
    case Stories      = "/stories"
    case Creators     = "/creators"
    
    public var pathValue: String {
        return self.rawValue
    }
}

//public enum MarvelSectionURL: String {
//    case Characters   = "/characters"
//    case Comics       = "/comics"
//    case Events       = "/events"
//    case Series       = "/series"
//    case Stories      = "/stories"
//    case Creators     = "/creators"
//
//}

//public enum MarvelSection: String {
//    case Characters, Comics, Events, Series, Stories, Creators
//    
//    public var urlValue: String {
//        switch self {
//        case .Characters: return MarvelSectionURL.Characters.rawValue
//        case .Comics:     return MarvelSectionURL.Comics.rawValue
//        case .Events:     return MarvelSectionURL.Events.rawValue
//        case .Series:     return MarvelSectionURL.Series.rawValue
//        case .Stories:    return MarvelSectionURL.Stories.rawValue
//        case .Creators:   return MarvelSectionURL.Creators.rawValue
//        }
//    }
//}

class URLConstruct: MarvelURLConstructor {
    static func configureURLString(apiDomain:MarvelDomainConsts, section: MarvelSection) -> String {
        let domain      = apiDomain.urlValue
        let subdomain   = section.pathValue
        return domain + subdomain
    }
}

public enum MarvelSectionType: Int {
    case Default = 0, Details, Subdetails
}

