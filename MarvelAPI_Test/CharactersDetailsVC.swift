//
//  CharactersDetailsVC.swift
//  MarvelTestApp_Kosyakov
//
//  Created by Alex Kosyakov on 01.02.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import UIKit

enum ActiveRow {
    case Thumb, Comics, Stories, Series, Description
    
    var sectionTitle: String {
        switch self {
        case .Thumb:       return "Hero"
        case .Comics:      return "Comics"
        case .Stories:     return "Stories"
        case .Series:      return "Series "
        case .Description: return "Description"
        }
    }
    
    func sectionTitle(character:Character?) -> String {
        switch self {
        case .Thumb:       return self.sectionTitle
        case .Comics:      return self.sectionTitle  + " \(character?.comics?.count  ?? 0)"
        case .Stories:     return self.sectionTitle  + " \(character?.stories?.count ?? 0)"
        case .Series:      return self.sectionTitle  + " \(character?.series?.count  ?? 0)"
        case .Description: return self.sectionTitle
        }
    }
}

class CharactersDetailsVC: RefreshableViewController {
    
    var character: Character?
    var closeHandler:(()->())?
    var activeRows: [ActiveRow] = [.Thumb, .Comics, .Stories, .Series, .Description]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        loadRefreshControl()
    }
}

extension CharactersDetailsVC {
    var viewModel: CharacterDetailsModel {
        return CharacterDetailsModel(apiService: self.apiService)
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

extension CharactersDetailsVC {
    override func refreshDidStart() {
        guard let characterItem = character, characterID = characterItem.uid?.integerValue else { return }
        handleUpdate(.Refreshing)
        viewModel.updateDetails(characterID) { error in
            self.handleError(error)
            self.tableView.reloadData()
            self.handleUpdate(.Default)
        }
    }
    
    func handleError(error: NSError?) {
        if error != nil {
            AlertHelper.showSimpleAlertFromError(error!, inContext: self)
        }
    }
}

extension CharactersDetailsVC {
    @IBAction func closeDidPress() {
        if let handler = closeHandler { handler() }
    }
}

extension CharactersDetailsVC: UITableViewDataSource {
    
    private struct CellIdentifiers {
        static let thumbCell   = "CharacterCell"
        static let sectionCell = "SectionCell"
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeRows.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        switch activeRows[indexPath.row] {
        case .Thumb:     return tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.thumbCell, forIndexPath: indexPath)   as! CharacterCell
        default:         return tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.sectionCell, forIndexPath: indexPath) as! SectionCell
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let characterItem = character  else { return }
        let activeRow:ActiveRow = activeRows[indexPath.row]
        switch activeRows[indexPath.row] {
        case .Thumb: guard let characterCell = cell as? CharacterCell else { return }
            characterCell.character = characterItem
            characterCell.prepareData(characterItem)
            characterCell.reloadData()
        default:  guard let sectionCell = cell as? SectionCell else { return }
        let sectionVars = SectionVariables(name:activeRow.sectionTitle(characterItem))
        sectionCell.reloadData(sectionVars)
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch activeRows[indexPath.row] {
        case .Thumb: return UIScreen.mainScreen().bounds.size.width
        default:     return (UIScreen.mainScreen().bounds.size.height + 20 - UIScreen.mainScreen().bounds.size.width)/(CGFloat(activeRows.count) - 1)
        }
    }
}

extension CharactersDetailsVC: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let characterItem = character else { return }
        
        let activeRow:ActiveRow = activeRows[indexPath.row]
        switch activeRow {
        case .Thumb: return
        case .Description: guard let text = characterItem.descript else { return }
        router.openTextVC(text, inContext: navigationController, dismissCompletion: closeHandler)
        default: router.openSubsecton(activeRow, character: characterItem, context: navigationController, dismissCompletion:closeHandler)
        }
       
    }
}

extension CharactersDetailsVC {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
