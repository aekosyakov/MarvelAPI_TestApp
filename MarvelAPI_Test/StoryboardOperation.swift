//
//  StoryboardOperation.swift
//  EatnSleep
//
//  Created by Andrey Kladov on 10/07/15.
//  Copyright © 2015 Andrey Kladov. All rights reserved.
//

import UIKit

public class StoryboardOperation: Operation {
	
	var storyboard: UIStoryboard {
		guard let name = storyboardName else { return UIStoryboard(name: "Main", bundle: storyboardBundle) }
		return UIStoryboard(name: name, bundle: storyboardBundle)
	}
	
	var segueOrStoryboardId: String?
	var presentationContext: UIViewController?
	
	var storyboardBundle: NSBundle?
	var storyboardName: String?
	
	init(storyboardName name: String? = nil, segueOrStoryboardId storyboardId: String? = nil, presentationContext vc: UIViewController? = nil) {
		self.storyboardName = name
		self.segueOrStoryboardId = storyboardId
		self.presentationContext = vc
		super.init()
	}
	
	override public func execute() {
		guard let vc = presentationContext, id = segueOrStoryboardId else { finishWithError(NSError(code: .ExecutionFailed)); return }
		vc.performSegueWithIdentifier(id, sender: self)
	}
	
}

class ModalPresentationOperation: StoryboardOperation {
	
	var updateUIBlock: (Void -> Void)?
	
	init(presentationContext vc: UIViewController? = nil, updateUIBlock block: (Void -> Void)? = nil) {
		updateUIBlock = block
		super.init(presentationContext: vc ?? UIApplication.sharedApplication().keyWindow?.rootViewController)
	}
	
}