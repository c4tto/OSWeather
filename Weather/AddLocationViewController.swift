//
//  AddLocationViewController.swift
//  Weather
//
//  Created by Ondřej Štoček on 25.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var closeBarButtonItem: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchDisplayController?.displaysSearchBarInNavigationBar = true
        self.searchDisplayController?.navigationItem.rightBarButtonItem = closeBarButtonItem
    }
    
    override func viewWillAppear(animated: Bool) {
        self.searchDisplayController?.searchBar.becomeFirstResponder()
    }
    
    // MARK: - Tablew View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        return cell
    }
}
