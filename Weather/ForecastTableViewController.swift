//
//  ForecastTableViewController.swift
//  Weather
//
//  Created by Ondřej Štoček on 21.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

class ForecastTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var contentInset = self.tableView.contentInset
        contentInset.top = self.parentViewController?.topLayoutGuide.length ?? contentInset.top
        self.tableView.contentInset = contentInset
        
        tableView?.registerNib(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "weatherCell")
    }

    override func viewWillAppear(animated: Bool) {
        parentViewController?.navigationItem.title = "[Selected City]"
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 83;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("weatherCell", forIndexPath: indexPath) as WeatherTableViewCell
        return cell
    }
}
