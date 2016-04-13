//
//  CharactersListVC.swift
//  MarvelTestApp_Kosyakov
//
//  Created by Alex Kosyakov on 31.01.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import ObjectiveC
import ReactiveCocoa

private extension Selector {
    static let updateItems  = #selector(CharactersListVC.updateItems)
    static let getMoreItems = #selector(CharactersListVC.getMoreItems)
}

class CharactersListVC: RefreshableViewController {
    @IBOutlet weak var footerActivityView: UIActivityIndicatorView!

    var fetchedController: NSFetchedResultsController!
    var refreshState:RefreshState = .Default
    var offset = 0

    struct TableViewConsts {
        static let refreshHeight: CGFloat = 150
        static let screenWidth:   CGFloat = UIScreen.mainScreen().bounds.size.width
    }
    
    enum DownloadState {
        case Update, GetMore
    }
}

extension CharactersListVC {
    override func loadView() {
        super.loadView()
        setupInterface()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFetchedController()
        performFetch()
    }
    
    func setupInterface() {
        handleTableViewContentInsect(.Default)
        loadRefreshControl()
    }
}

extension CharactersListVC {
    var viewModel: CharacterListModel {
        return CharacterListModel(apiService: self.apiService)
    }
    
    var apiService: MarvelApiService {
        return  MarvelApiServiceImpl(apiClient: self.apiClient, parser: self.parser)
    }
    
    var apiClient: MarvelApiClient {
        return  MarvelApiClientImpl(type: .Alamofire)
    }
    
    var parser: Parser {
        return ParserIml()
    }
    
    var router: MainRouter {
        return RouterImpl()
    }
}

extension CharactersListVC {
    func updateItems() {
        if refreshState == . Refreshing { return }
        reloadRefreshState(.Update, state: .Refreshing)
        viewModel.getItems() { error in
            self.handleError(error)
        }
    }

    func getMoreItems() {
        if refreshState == . Refreshing { return }
        reloadRefreshState(.GetMore, state: .Refreshing)
        viewModel.getItems(fetchedController.fetchedObjects?.count ?? 0) { error in
            self.handleError(error)
        }
    }
    
    func handleError(error: NSError?) {
        if error != nil {
            AlertHelper.showSimpleAlertFromError(error!, inContext: self)
        }
        self.reloadRefreshState(.GetMore, state: .Default)
        self.performFetch()
    }
}

extension CharactersListVC {
    
    override func refreshDidStart() {
        updateItems()
    }
    
    func reloadRefreshState(type:DownloadState, state: RefreshState) {
        refreshState = state
        switch type {
        case .Update:  handleUpdate(refreshState)
        case .GetMore: handleGetMore(refreshState); handleTableViewContentInsect(refreshState)
        }
    }
}

extension CharactersListVC {
    
    func handleGetMore(state:RefreshState) {
        switch state {
        case .Default:    footerActivityView.stopAnimating()
        case .Refreshing: footerActivityView.startAnimating();
        }
    }
    
    func handleTableViewContentInsect(state:RefreshState) {
        switch state {
        case .Default:    tableView?.contentInset = UIEdgeInsetsMake(0.0, 0.0, -40.0, 0.0)
        case .Refreshing: tableView?.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        }
    }
}

extension CharactersListVC: UITableViewDataSource {
    
    private struct CellIdentifiers {
        static let characterCell = "CharacterCell"
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedController.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count =  fetchedController.sections?[section].numberOfObjects ?? 0
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let characterCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.characterCell, forIndexPath: indexPath) as! CharacterCell
        if let character = fetchedController.objectAtIndexPath(indexPath) as? Character {
            characterCell.character = character
        }
        return characterCell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let characterCell = cell as? CharacterCell else { return }
        if let character = fetchedController.objectAtIndexPath(indexPath) as? Character {
            characterCell.prepareData(character)
        }
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let characterCell = cell as? CharacterCell else { return }
        characterCell.resetData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TableViewConsts.screenWidth
    }    
}


extension CharactersListVC: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let character = fetchedController.objectAtIndexPath(indexPath) as? Character {
            router.showDetailsVC(character, inContext:self.navigationController, dismissCompletion:nil)
        }
    }
}

extension CharactersListVC: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
         self.getMoreItemsIfPossible(scrollView.contentOffset.y)
    }
    
    func getMoreItemsIfPossible(offset: CGFloat) {
        let rowCount = fetchedController.sections?[0].numberOfObjects ?? 0
        if (offset  >= tableView.contentSize.height  -  tableView.frame.size.height)  {
            switch refreshState {
            case .Default where rowCount > 0: getMoreItems()
            default: break
            }
        }
    }
}


extension CharactersListVC {
    private struct FetchConsts {
        static let fetchedControllerCacheName = "FetchedControllerCaches"
        static let characterEntiryName        = "Character"
    }
    
    private struct SortConsts {
        static let nameKey = "name"
        static let uidKey  = "uid"
    }
    
    private var fetchRequest: NSFetchRequest {
        let request = NSFetchRequest(entityName: FetchConsts.characterEntiryName)
        request.sortDescriptors = [NSSortDescriptor(key: SortConsts.nameKey, ascending: true)]
        return request
    }
    
    func loadFetchedController() {
        fetchedController = nil
        NSFetchedResultsController.deleteCacheWithName(FetchConsts.fetchedControllerCacheName)
        fetchedController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                       managedObjectContext:NSManagedObjectContext.mainThreadContext,
                                                       sectionNameKeyPath: nil,
                                                       cacheName: FetchConsts.fetchedControllerCacheName)
    }
    
    func performFetch() {
        do { try fetchedController?.performFetch() }
        catch let error { print("performFetch: \(error)") }
        tableView!.reloadData()
        offset = fetchedController.sections?.count ?? 0
    }
}

//extension CharactersListVC {
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return .LightContent
//    }
//    
//    override func prefersStatusBarHidden() -> Bool {
//        return false
//    }
//}