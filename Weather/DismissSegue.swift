//
//  DismissSegue.swift
//  Weather
//
//  Created by Ondřej Štoček on 22.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

class DismissSegue: UIStoryboardSegue {
    
    override func perform() {
        let sourceViewController = self.sourceViewController as UIViewController
        sourceViewController.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
