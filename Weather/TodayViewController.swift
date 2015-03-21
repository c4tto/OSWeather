//
//  FirstViewController.swift
//  Weather
//
//  Created by Ondřej Štoček on 21.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        parentViewController?.navigationItem.title = "Today"
    }
}

