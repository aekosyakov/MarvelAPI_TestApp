//
//  RandomColorCell.swift
//  MarvelTestApp_Kosyakov
//
//  Created by Alex Kosyakov on 02.02.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import UIKit
import RandomColorSwift

class RandomColorCell: UITableViewCell {
    override func awakeFromNib() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.contentView.backgroundColor  = randomColor()
        })
    }
}
