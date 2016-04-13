//
//  SubsectionCell.swift
//  MarvelTestApp_Kosyakov
//
//  Created by Alex Kosyakov on 02.02.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import UIKit

struct ItemData {
    let item: ItemObject?
}

class SubsectionCell: SectionCell { }

extension SubsectionCell: UpdatingInfo {
    typealias InfoData = ItemData
    func updateInfoData(infoData: ItemData) {
        guard let item = infoData.item else { return }
        self.titleLabel.text = item.name ?? "-"
    }
}