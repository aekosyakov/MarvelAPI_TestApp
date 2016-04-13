//
//  ParserIml+Characters.swift
//  MarvelAPI_Test
//
//  Created by Alex Kosyakov on 12.04.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import Foundation
import CoreData

// MARK: CHARACTERS

extension ParserIml {
    func parseCharactersData(data: AnyObject, sectionInfo: SectionData, completion: (()->())?) {
        let sectionType = sectionInfo.details
        switch sectionType {
        case .Default:    parseCharactersList(data, completion: completion)
        case .Details:    parseCharacterDetails(data, completion: completion)
        case .Subdetails: parseCharacterDetailsSubdomain(sectionInfo.section, data: data, completion: completion)
        }
        
    }
    
    func parseCharactersList(data: AnyObject, completion: (()->())?) {
        guard let completionHandler = completion else { return }
        guard let results           = data["results"] as? [JSONObject]
            else { completionHandler(); return }
        
        NSManagedObjectContext.saveDataInBackground({ localContext in
            for itemDict in results {
                let characterID = itemDict["id"]       as? NSNumber ?? NSNumber(integer: 0)
                let modified    = itemDict["modified"] as? String ?? ""
                let predicate   = NSPredicate(format: "uid == %@", characterID)
                
                var character = Character.findFirstOne(predicate, sortDescriptors: nil, inContext: localContext) as? Character
                switch (character) {
                case .Some(let charact) where charact.modified == modified: /* print("nothiing to do with character");*/ break
                case .Some(let charact) where charact.modified != modified: /* print("update character"); */  charact.mapFromJSONObject(itemDict, context: localContext)
                default:
                    character = localContext.createEntity(Character);
                    character!.mapFromJSONObject(itemDict, context: localContext)
                   /* print("create character")*/
                }
            }
            
            }, completion: completion)
        
    }
    
    func parseCharacterDetails(data: AnyObject, completion: (()->())?) {
        parseCharactersList(data, completion: completion)
    }
    
    func parseCharacterDetailsSubdomain(subdomain:MarvelSection, data: AnyObject, completion: (()->())?) {
        switch subdomain {
        case .Comics:  parseCharactersComics (data, completion: completion)
        case .Stories: parseCharactersStories(data, completion: completion)
        case .Series:  parseCharactersSeries (data, completion: completion)
        default: return;
        }
    }
    
    func parseCharactersComics(data: AnyObject, completion: (()->())?)  { }
    
    func parseCharactersStories(data: AnyObject, completion: (()->())?) { }
    
    func parseCharactersSeries(data: AnyObject, completion: (()->())?)  { }
    
}