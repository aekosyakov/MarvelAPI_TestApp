//
//  MarvelApiServiceImpl.swift
//  MarvelAPI_Test
//
//  Created by Alex Kosyakov on 11.04.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import Foundation
import CryptoSwift

public class MarvelApiServiceImpl: MarvelApiService {
    var apiClient: MarvelApiClient
    var parser: Parser
    
    required public init(apiClient: MarvelApiClient, parser: Parser) {
        self.apiClient = apiClient
        self.parser = parser
    }
}

public extension MarvelApiServiceImpl {
    func loadCharactersList(count:Int?, offset:Int?, completion: ((NSError?)->())?) {
        let fetchParams = ["limit" : count ?? 0, "offset" : offset ?? 0]
        loadSectionList(.Characters, fetchParams: fetchParams, completion: completion)
    }
    
    func loadCharacterDetails(characterID:Int, completion: ((NSError?)->())?) {
        let fetchParams = ["characterId" : characterID]
        loadSectionDetails(.Characters, sectionID: characterID, fetchParams: fetchParams, completion: completion)
    }
    
    func loadCharactersSubsection(sectionID:Int, subsection:MarvelSection, completion: ((NSError?)->())?) {
        loadSectionDetailsSubsection(.Characters, sectionID: sectionID, subsection: subsection, fetchParams: nil, completion: completion)
    }
}

extension MarvelApiServiceImpl {
    func loadSectionList(section:MarvelSection, fetchParams: FetchParams, completion:((NSError?)->())?) {
        let sectionData = (section, details:MarvelSectionType.Default)
        loadInfo(sectionData, url: nil, fetchParams: fetchParams, completion: completion)
    }
    
    func loadSectionDetails(section:MarvelSection, sectionID:Int, fetchParams: FetchParams, completion:((NSError?)->())?) {
        let url = "/\(sectionID)"
        let sectionData = (section, details:MarvelSectionType.Details)
        loadInfo(sectionData, url: url, fetchParams: fetchParams, completion: completion)
    }
    
    func loadSectionDetailsSubsection(section:MarvelSection, sectionID:Int, subsection:MarvelSection, fetchParams: FetchParams, completion:((NSError?)->())?){
        let url = "/\(sectionID)" + subsection.pathValue
        let sectionData = (section, details:MarvelSectionType.Subdetails)
        loadInfo(sectionData, url:url, fetchParams: fetchParams, completion: completion)
    }
}

extension MarvelApiServiceImpl {

    func baseURLString(section:MarvelSection) -> String {
        return URLConstruct.configureURLString(MarvelDomainConsts.Gateaway, section:section)
    }
    
    func loadInfo(sectionData:SectionData, url: String?, fetchParams: FetchParams, completion: ((NSError?)->())?) {
        guard let completionHandler = completion else { return }
        
        self.isReachable { reachable in
            switch reachable {
            case false: completionHandler(NSError(domain:"", code: 0, userInfo: ["message" : "Network is unavailable"]))
            default: break
            }
        }
        

        let method     = baseURLString(sectionData.section) + (url ?? "")
        var params     = fetchParams
        
        let ts         = NSDate().timeIntervalSince1970.description
        let publicKey  = MarvelAPIConsts.PublicKey
        let privateKey = MarvelAPIConsts.PrivateKey
        
        let hash = ("\(ts)\(privateKey)\(publicKey)").md5()
        
        params?["apikey"] = publicKey
        params?["hash"]   = hash
        params?["ts"]     = ts
        
        print("params \(params)")
        
    
        apiClient.requestData(method, params: params) { (response, error)  in
            guard let responseData = response where error == nil else { completionHandler(error); return }
            self.parser.parseJSONData(responseData, sectionInfo:sectionData, completion: { () -> () in
                completionHandler(nil)
            })
        }
    }
}

// MARK: Reachability
extension MarvelApiServiceImpl {
    func isReachable(completion: ((Bool)->())?) {
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch { print("Unable to create Reachability"); return }
        
        if let competionHandler = completion { competionHandler(reachability.isReachable()) }
        
    }
}
