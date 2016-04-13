//
//  Characters+Mapping.swift
//  MarvelTestApp_Kosyakov
//
//  Created by Alex Kosyakov on 31.01.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

extension Character {
    override func mapFromJSONObject(object: JSONObject?, context: NSManagedObjectContext) {
        
        uid      = object?["id"]          as? NSNumber ?? NSNumber(integer: 0)
        name     = object?["name"]        as? String   ?? ""
        descript = object?["description"] as? String   ?? ""
        modified = object?["modified"]    as? String   ?? ""
        
        if let thumb = object?["thumbnail"] as? JSONObject {
            let path = thumb["path"]      as? String ?? ""
            let ext  = thumb["extension"] as? String ?? ""
            thumbnail = "\(path).\(ext)"
        }
        
        if let stories = object?["stories"] as? JSONObject, items  = stories["items"] as? [JSONObject] {
            for storyDict in items {
                let story = context.createEntity(Story)
                story.mapFromJSONObject(storyDict, context: context)
                story.character = self
            }
        }
        
        if let series = object?["series"] as? JSONObject, items  = series["items"] as? [JSONObject] {
            for serieDict in items {
                let serie = context.createEntity(Serie)
                serie.mapFromJSONObject(serieDict, context: context)
                serie.character = self
            }
        }
        
        if let comics = object?["comics"] as? JSONObject, items  = comics["items"] as? [JSONObject] {
            for comicDict in items {
                let comic = context.createEntity(Comics)
                comic.mapFromJSONObject(comicDict, context: context)
                comic.character = self
            }
        }
    }
    
    func saveImageData(completion:((NSData)->())?) {
        guard let handler = completion, thumb = thumbnail else { return }
        print("thumb \(thumb)")
        Alamofire.request(.GET, thumb).response() {
            (_, _, data, _) in self.thumbData = data
            handler(data!)
        }
    }
}