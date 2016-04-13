//
//  ItemObject+CoreDataProperties.swift
//  MarvelAPI_Test
//
//  Created by Alex Kosyakov on 12.04.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ItemObject {

    @NSManaged var name: String?
    @NSManaged var resourceURI: String?
    @NSManaged var thumbData: NSData?

}
