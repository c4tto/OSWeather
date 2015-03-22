//
//  SettingsTableViewController.swift
//  Weather
//
//  Created by Ondřej Štoček on 21.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var contentInset = self.tableView.contentInset
        contentInset.top = self.parentViewController?.topLayoutGuide.length ?? contentInset.top
        self.tableView.contentInset = contentInset
    }

    override func viewWillAppear(animated: Bool) {
        self.parentViewController?.navigationItem.title = "Settings"
    }
}
