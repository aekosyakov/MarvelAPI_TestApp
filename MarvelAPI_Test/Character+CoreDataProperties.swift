//
//  Character+CoreDataProperties.swift
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

extension Character {

    @NSManaged var descript: String?
    @NSManaged var modified: String?
    @NSManaged var name: String?
    @NSManaged var resourseURI: String?
    @NSManaged var thumbData: NSData?
    @NSManaged var thumbnail: String?
    @NSManaged var uid: NSNumber?
    @NSManaged var comics: NSSet?
    @NSManaged var series: NSSet?
    @NSManaged var stories: NSSet?

}
