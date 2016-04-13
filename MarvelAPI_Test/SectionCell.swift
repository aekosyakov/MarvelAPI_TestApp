//
//  SectionCell.swift
//  MarvelTestApp_Kosyakov
//
//  Created by Alex Kosyakov on 02.02.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import UIKit

struct SectionVariables {
    var name: String?
}

class SectionCell: RandomColorCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    func reloadData(variables:SectionVariables) {
        titleLabel?.text = nil
        titleLabel?.text = variables.name?.uppercaseString
    }
}
