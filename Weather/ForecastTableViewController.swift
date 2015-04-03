//
//  ForecastTableViewController.swift
//  Weather
//
//  Created by Ondřej Štoček on 21.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

class ForecastTableViewController: UITableViewController {
    
    var weatherDataItems: [WeatherDataItem]?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "weatherCell")
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.weatherDataItems = nil
        self.updateView()
        
        self.weatherDataModel.forecastForSelectedLocation {(weatherDataItems, error) in
            self.weatherDataItems = weatherDataItems
            self.updateView()
            self.displayError(error)
        }
    }
    
    func updateView() {
        if let weatherDataItems = self.weatherDataItems {
            self.navigationItem.title = weatherDataItems[0].locationName
        } else {
            self.navigationItem.title = nil
            // show loading spinner
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherDataItems?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 83;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("weatherCell", forIndexPath: indexPath) as WeatherTableViewCell
        
        if let weatherDataItem = self.weatherDataItems?[indexPath.row] {
            if let weakDayString = weatherDataItem.weakDayString {
                cell.titleLabel.text = weakDayString
            }
            if let conditionString = weatherDataItem.conditionString {
                cell.conditionLabel.text = conditionString
            }
            if let temperatureShortString = weatherDataItem.temperatureShortString {
                cell.temperatureLabel.text = temperatureShortString
            }
            if let image = weatherDataItem.image {
                cell.weatherImageView.image = image
            }
        }
        return cell
    }
}

