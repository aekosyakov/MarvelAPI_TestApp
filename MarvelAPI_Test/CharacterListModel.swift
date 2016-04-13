//
//  CharacterListModel.swift
//  MarvelAPI_Test
//
//  Created by Alex Kosyakov on 12.04.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import UIKit

class CharacterListModel: NSObject {
    var apiService: MarvelApiService
    var stepCount = 20
    init(apiService: MarvelApiService) {
        self.apiService = apiService
    }
}

extension CharacterListModel {
    func getItems(completion:((NSError?)->())?) {
        getItems(0, completion: completion)
    }
    
    func getItems(offset:Int, completion:((NSError?)->())?) {
        apiService.loadCharactersList(stepCount, offset: offset, completion: completion)
    }
}


class CachedImageStorage {
    
    static var cellCachedImages = [NSNumber: UIImage]()
    
    static func cacheImageFrom(data:NSData, cacheKey:NSNumber, completion:((UIImage, Bool)->())?) {
        if let handler = completion {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let image = UIImage(data: data)
                cellCachedImages[cacheKey] = image
                handler(UIImage(data: data)!, true)
            })
        }
        
    }
    
    static func getCachedImageFor(character:Character, completion:((UIImage, Bool)->())?)  {
        guard let handler = completion else { return }
        
        if let characterImage = cellCachedImages[character.uid!] {
            handler(characterImage, false)
        } else {
            if let data = character.thumbData {
                cacheImageFrom(data, cacheKey:character.uid!, completion:completion)
            } else {
                character.saveImageData({ data in
                    cacheImageFrom(data, cacheKey:character.uid!, completion:completion)
                })
            }
        }
    }
}
