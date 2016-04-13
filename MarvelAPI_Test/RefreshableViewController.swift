//
//  RefreshableViewController.swift
//  MarvelAPI_Test
//
//  Created by Alex Kosyakov on 13.04.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import UIKit

enum RefreshState: Int {
    case Default = 0, Refreshing
}

class RefreshableViewController: UIViewController {
    var refreshControl: UIRefreshControl?
    
    private struct Selectors {
        static let updateItems = #selector(RefreshableViewController.refreshDidStart)
    }
    
    private struct Consts {
        static let refreshHeight: CGFloat = 150
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func loadRefreshControl() {
        let refresh = UIRefreshControl(frame: CGRectMake(0, 0, Consts.refreshHeight, tableView.bounds.size.width))
        refresh.addTarget(self, action: Selectors.updateItems, forControlEvents: .ValueChanged)
        refresh.attributedTitle = NSAttributedString(string: "Updating..")
        tableView.addSubview(refresh)
        refreshControl = refresh
    }
    
    func refreshDidStart() { }
    
    func handleUpdate(state: RefreshState) {
        switch state {
        case .Default:    refreshControl?.endRefreshing()
        case .Refreshing: refreshControl?.beginRefreshing()
        }
    }
}
