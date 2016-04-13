//
//  Comics+Mapping.swift
//  MarvelTestApp_Kosyakov
//
//  Created by Alex Kosyakov on 31.01.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import Foundation
import CoreData

extension Comics {
    override func mapFromJSONObject(object: JSONObject?, context: NSManagedObjectContext) {
        type = object?["type"] as? String ?? ""
        super.mapFromJSONObject(object, context: context)
    }
}