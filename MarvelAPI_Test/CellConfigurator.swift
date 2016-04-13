//
//  CellConfigurator.swift
//  VKAdminka
//
//  Created by Alex Kosyakov on 09.01.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import UIKit

public enum UpdateState: Int {
    case Default = 0, Updating
}

protocol UpdatingUI {
    func updateUI(state:UpdateState)
}

protocol UpdatingInfo {
    associatedtype InfoData
    func updateInfoData(infoData: InfoData)
}


struct CellConfigurator<Cell where Cell: UpdatingInfo, Cell: UITableViewCell> {
    let infoData: Cell.InfoData
    let reuseIdentifier: String = NSStringFromClass(Cell)
    let cellClass: AnyClass     = Cell.self
}

extension CellConfigurator: CellConfiguratorType {
    func updateCell(cell: UITableViewCell) {
        if let cell = cell as? Cell {
            cell.updateInfoData(infoData)
        }
    }
}

protocol CellConfiguratorType {
    var reuseIdentifier:  String   { get }
    var cellClass:        AnyClass { get }
    func updateCell(cell: UITableViewCell)
}

