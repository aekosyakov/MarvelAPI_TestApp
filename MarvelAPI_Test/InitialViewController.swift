//
//  InitialViewController.swift
//  MarvelAPI_Test
//
//  Created by Alex Kosyakov on 11.04.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    var number: NSNumber? {
        willSet {
            print("newValue \(newValue)")
        }
    }
    
    private let kEnterApplicationSegue = "enterApplication"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        enterApplication()
    }
}

extension InitialViewController {
    func enterApplication() {
       
       RouterImpl().openCharacterList(self.navigationController, animated:false)
    }
}