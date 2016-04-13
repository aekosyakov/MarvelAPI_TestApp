//
//  ItemObject+Mapping.swift
//  MarvelTestApp_Kosyakov
//
//  Created by Alex Kosyakov on 31.01.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import Foundation
import CoreData

extension ItemObject {
    override func mapFromJSONObject(object: JSONObject?, context: NSManagedObjectContext) {
        resourceURI  = object?["resourceURI"] as? String ?? ""
        name         = object?["name"]        as? String ?? ""
    }
}