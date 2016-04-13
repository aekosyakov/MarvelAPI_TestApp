//
//  CharacterDetailsModel.swift
//  MarvelAPI_Test
//
//  Created by Alex Kosyakov on 13.04.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import UIKit

class CharacterDetailsModel: NSObject {
    var apiService: MarvelApiService
    init(apiService: MarvelApiService) {
        self.apiService = apiService
    }
}

extension CharacterDetailsModel {
    func updateDetails(characterID:Int, completion:((NSError?)->())?) {
        apiService.loadCharacterDetails(characterID, completion: completion)
    }
}
