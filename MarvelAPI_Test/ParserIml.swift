//
//  ParserIml.swift
//  MarvelAPI_Test
//
//  Created by Alex Kosyakov on 12.04.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import UIKit

class ParserIml: Parser {
    func parseJSONData(data: AnyObject, sectionInfo: SectionData, completion: (()->())?) {
        guard let completionHandler = completion else { return }
        guard let response     = data             as? JSONObject,
            responseData = response["data"] as? JSONObject
            else { completionHandler(); return }
        
        switch sectionInfo.section {
        case .Characters: parseCharactersData(responseData, sectionInfo: sectionInfo, completion: completion)
        case .Comics:     parseComicsData(responseData, sectionInfo: sectionInfo, completion: completion)
        case .Creators:   break
        case .Events:     break
        case .Series:     break
        case .Stories:    break
        }
    }
}
