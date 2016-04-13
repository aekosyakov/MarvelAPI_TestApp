//
//  Mappable.swift
//  MarvelTestApp_Kosyakov
//
//  Created by Alex Kosyakov on 31.01.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import Foundation
import CoreData

protocol MappableObject {
	func mapFromJSONObject(object: JSONObject?, context: NSManagedObjectContext)
}

extension MappableObject {
	func mapFromJSONObject(object: JSONObject?) {
		mapFromJSONObject(object, context: NSManagedObjectContext.mainThreadContext)
	}
}

extension NSManagedObject: MappableObject {
	func mapFromJSONObject(object: JSONObject?, context: NSManagedObjectContext) {}
}