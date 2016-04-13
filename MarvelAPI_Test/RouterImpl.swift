//
//  RouterImpl.swift
//  MarvelAPI_Test
//
//  Created by Alex Kosyakov on 11.04.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import UIKit

public class RouterImpl: MainRouter {
    var mainStoryboard = UIStoryboard(name: StoryboardConsts.kMainStoryboard, bundle: NSBundle.mainBundle())
    
    private struct StoryboardConsts {
        static let kMainStoryboard          = "Main"
        static let kCharactersListID        = "CharactersListVC"
        static let kCharactersDetailsID     = "CharactersDetailsVC"
        static let kCharactersSubsectionID  = "ConfigurableListVC"
        static let kSimpleTextID            = "SimpleTextVC"
    }
    static var context: UIViewController?
}

/* CHARACTER LIST */
extension RouterImpl {
    func openCharacterList(inContext:UIViewController?, animated:Bool) {
        guard let vc = mainStoryboard.instantiateViewControllerWithIdentifier(StoryboardConsts.kCharactersListID) as? CharactersListVC, context = inContext as? UINavigationController
            else { return }
        context.pushViewController(vc, animated: animated)
    }
}


/* CHARACTER DETAILS */
extension RouterImpl {
    func showDetailsVC(character: Character, inContext:UIViewController?, dismissCompletion:(()->())?) {
        
        guard let vc = mainStoryboard.instantiateViewControllerWithIdentifier(StoryboardConsts.kCharactersDetailsID) as? CharactersDetailsVC else { return }
        
        let context = inContext ??  UIApplication.sharedApplication().keyWindow?.rootViewController
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBarHidden = true
        nav.modalPresentationStyle = .FullScreen
        nav.modalTransitionStyle   = .CoverVertical
        
        vc.character = character
        vc.closeHandler = {
            context!.dismissViewControllerAnimated(true, completion:nil)
            if let handler = dismissCompletion { handler() }
        }
        context!.presentViewController(nav, animated: true, completion: nil)
    }
}


/* CHARACTERS SUBSECTION */
extension RouterImpl {
    func openSubsecton(subsection: ActiveRow,
                              character:Character,
                              context:UIViewController?,
                              dismissCompletion:(()->())?) {
        var items = [ItemObject]()
        var title = ""
        switch subsection {
        case .Comics: guard let objects = character.comics?.allObjects  as? [Comics] else { return }; items = objects; title = ActiveRow.Comics.sectionTitle
        case .Series: guard let objects = character.series?.allObjects  as? [Serie]  else { return }; items = objects; title = ActiveRow.Series.sectionTitle
        case .Stories:guard let objects = character.stories?.allObjects as? [Story]  else { return }; items = objects; title = ActiveRow.Stories.sectionTitle
        default: return
        }
        openConfigurableListVC(items, title: title, inContext: context, dismissCompletion: dismissCompletion)
    }
    
    func openConfigurableListVC(objects:[ItemObject]?,
                                       title:String,
                                       inContext:UIViewController?,
                                       dismissCompletion:(()->())?) {
        
        guard let vc = mainStoryboard.instantiateViewControllerWithIdentifier(StoryboardConsts.kCharactersSubsectionID) as? ConfigurableListVC,
            items = objects,
            context = inContext as? UINavigationController
            where items.count > 0 else { return }
        
        var tempArray: Array <CellConfiguratorType> = Array()
        for item in items {
            tempArray.append(CellConfigurator<SubsectionCell>(infoData: ItemData(item:item)))
        }
        vc.items = tempArray
        vc.title = title
        vc.closeHandler = {
            if let handler = dismissCompletion { handler() }
        }
        context.pushViewController(vc, animated: true)
    }
}

extension RouterImpl {
    func openTextVC(text:String, inContext:UIViewController?, dismissCompletion:(()->())?) {
        guard let vc = mainStoryboard.instantiateViewControllerWithIdentifier(StoryboardConsts.kSimpleTextID) as? SimpleTextVC, context = inContext as? UINavigationController else { return }
        vc.text = text
        vc.closeHandler = { if let handler = dismissCompletion { handler() } }
        context.pushViewController(vc, animated: true)
    }
}
