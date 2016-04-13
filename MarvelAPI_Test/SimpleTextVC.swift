//
//  SimpleTextVC.swift
//  MarvelTestApp_Kosyakov
//
//  Created by Alex Kosyakov on 02.02.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import UIKit
import RandomColorSwift

class SimpleTextVC: UIViewController {
    @IBOutlet weak var textView: UITextView!
    var closeHandler:(()->())?
    
    var text: String?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textView.text = text?.characters.count > 0 ? text : "no description"
        textView.textColor = UIColor.whiteColor()
        view.backgroundColor = randomColor()
    }
}

extension SimpleTextVC {
    @IBAction func closeDidPress() {
        if let handler = closeHandler { handler() }
    }
    
    @IBAction func backDidPress() {
        navigationController?.popViewControllerAnimated(true)
    }
}


extension SimpleTextVC {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}