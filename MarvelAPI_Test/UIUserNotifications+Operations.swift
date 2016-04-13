/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
A convenient extension to UIKit.UIUserNotificationSettings.
*/

#if os(iOS)

import UIKit

public extension UIUserNotificationSettings {
    func contains(settings: UIUserNotificationSettings) -> Bool {
        if !types.contains(settings.types) { return false }
        
        let otherCategories = settings.categories ?? []
        let myCategories = categories ?? []
        
        return myCategories.isSupersetOf(otherCategories)
    }
    
    func settingsByMerging(settings: UIUserNotificationSettings) -> UIUserNotificationSettings {
        let mergedTypes = types.union(settings.types)
        
        let myCategories = categories ?? []
        var existingCategoriesByIdentifier = Dictionary(sequence: myCategories) { $0.identifier }
        
        let newCategories = settings.categories ?? []
        let newCategoriesByIdentifier = Dictionary(sequence: newCategories) { $0.identifier }
        
        for (newIdentifier, newCategory) in newCategoriesByIdentifier {
            existingCategoriesByIdentifier[newIdentifier] = newCategory
        }
        
        let mergedCategories = Set(existingCategoriesByIdentifier.values)
        return UIUserNotificationSettings(forTypes: mergedTypes, categories: mergedCategories)
    }
}

#endif
