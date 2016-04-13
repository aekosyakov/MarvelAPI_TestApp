//
//  CharacterCell.swift
//  MarvelTestApp_Kosyakov
//
//  Created by Alex Kosyakov on 31.01.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import UIKit
import RandomColorSwift

struct CharacterVariables {
    var name: String?
    var indexRow: Int
}

protocol CharacterCellProtocol {
    var titleLabel:     UILabel! { get }
    var thumbImageView: UIImageView! { get }
    var character: Character? { get }

    func reloadData()
    func prepareData(character: Character)
}

class CharacterCell: RandomColorCell, CharacterCellProtocol {
    
    @IBOutlet weak var titleLabel:     UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    var character: Character?
    
    func reloadData() {
        guard let char = character, image  = CachedImageStorage.cellCachedImages[char.uid!] else { return }
        displayImage(image, animated: true)
        titleLabel.text = char.name
        
    }
    
    func prepareData(character: Character) {
        resetData()
        CachedImageStorage.getCachedImageFor(character, completion: { [weak self] image, justUploaded in
            self?.reloadData()
        })
    }

    func resetData() {
        titleLabel?.text = nil
        thumbImageView.image = nil
    }
    
    private func displayImage(image:UIImage, animated:Bool) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.thumbImageView.image = image
            self.titleLabel?.hidden = false
            if animated == true {
                self.thumbImageView.runFade()
            }
        })
    }
    
}
