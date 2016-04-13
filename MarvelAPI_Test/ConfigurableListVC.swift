//
//  ConfigurableListVC.swift
//  VKAdminka
//
//  Created by Alex Kosyakov on 09.01.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import UIKit

protocol Refreshable {
    func configureRefreshControl()
    func refreshData()
}

class ConfigurableListVC: UIViewController {
    
    private struct RefreshAction {
        static let refreshData = #selector(ConfigurableListVC.refreshData)
    }
    
    var updateState: UpdateState = UpdateState.Default
    var selectHandler:((Int)->())?
    var closeHandler: (()->())?
    
    var items: [CellConfiguratorType]?
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 60
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
    }
}

extension ConfigurableListVC {
    @IBAction func closeDidPress() {
        if let handler = closeHandler { handler() }
    }
    
    @IBAction func backDidPress() {
        navigationController?.popViewControllerAnimated(true)
    }
}

extension ConfigurableListVC: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let items = items where items.count > 0 else { return UITableViewCell() }
        let cellConfigurator = items[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellConfigurator.reuseIdentifier, forIndexPath: indexPath)
        cellConfigurator.updateCell(cell)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension ConfigurableListVC: UITableViewDelegate {
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let handler = selectHandler else { return }
        handler(indexPath.row)
    }
}

extension ConfigurableListVC {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

extension ConfigurableListVC: Refreshable {
    
    func configureRefreshControl() {
        let control = UIRefreshControl()
        control.addTarget(self, action: RefreshAction.refreshData, forControlEvents: .ValueChanged)
        tableView.addSubview(control)
        refreshControl = control
    }
    
    func refreshData() { return }
}

extension ConfigurableListVC: UpdatingUI {
    
    func updateUI(state: UpdateState) {
        updateRefreshControl(state)
        updateState = state
        tableView.reloadData()
    }
    
    func updateRefreshControl(state:UpdateState) {
        switch state {
        case .Default:  refreshControl?.endRefreshing()
        case .Updating: refreshControl?.beginRefreshing()
        }
        
    }
}

