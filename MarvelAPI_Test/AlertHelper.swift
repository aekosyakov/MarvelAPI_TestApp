//
//  AlertHelper.swift
//  MarvelAPI_Test
//
//  Created by Alex Kosyakov on 12.04.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

import UIKit

public class AlertHelper: NSObject {
    static func showSimpleAlertFromError(error: NSError, inContext: UIViewController) {
        var alertMessage = error.description
        if let message = error.userInfo["message"] as? String {
            alertMessage = message
        }
        
        let alertController = UIAlertController(title: "Something's wrong", message: alertMessage, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
        
        let context = inContext ??  UIApplication.sharedApplication().keyWindow?.rootViewController
        context?.presentViewController(alertController, animated: true, completion: nil)
    }
}
