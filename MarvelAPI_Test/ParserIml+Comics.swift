//
//  ParserIml+Comics.swift
//  MarvelAPI_Test
//
//  Created by Alex Kosyakov on 12.04.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import Foundation

import CoreData

// COMICS

extension ParserIml {
    func parseComicsData(data: AnyObject, sectionInfo: SectionData, completion: (()->())?) {
        let sectionType = sectionInfo.details
        switch sectionType {
        case .Default:    parseCharactersList  (data, completion: completion)
        case .Details:    parseCharacterDetails(data, completion: completion)
        case .Subdetails: parseCharacterDetailsSubdomain(sectionInfo.section, data: data, completion: completion)
        }
        
    }
    
    func parseComicsList(data: AnyObject, completion: (()->())?)    { }
    
    func parseComicsDetails(data: AnyObject, completion: (()->())?) { }
    
    func parseComicsDetailsSubdomain(subdomain:MarvelSection, data: AnyObject, completion: (()->())?) {
        switch subdomain {
        case .Comics:  parseCharactersComics (data, completion: completion)
        case .Stories: parseCharactersStories(data, completion: completion)
        case .Series:  parseCharactersSeries (data, completion: completion)
        default: return;
        }
    }
    
    
}