//
//  Router.swift
//  MarvelAPI_Test
//
//  Created by Alex Kosyakov on 11.04.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import UIKit

protocol Router {
    var storyboard: UIStoryboard? { get set }
    init(storyboard:UIStoryboard?)
}

protocol MainRouter {
    func openCharacterList(inContext:UIViewController?, animated:Bool)
    func showDetailsVC(character: Character, inContext:UIViewController?, dismissCompletion:(()->())?)
    func openSubsecton(subsection: ActiveRow,
                       character:Character,
                       context:UIViewController?,
                       dismissCompletion:(()->())?)
    func openTextVC(text:String, inContext:UIViewController?, dismissCompletion:(()->())?)
}