//
//  ForecastTableViewController.swift
//  Weather
//
//  Created by Ondřej Štoček on 21.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

class ForecastTableViewController: UITableViewController {
    
    var cachedWeatherDataItems: [WeatherDataItem]?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "weatherCell")
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.weatherDataModel.forecastForCurrentLocation { (placemark, weatherDataItems, error) in
            self.displayWeather(placemark, weatherDataItems)
            if let error = error {
                println(error)
            }
        }
    }
    
    func displayLocation(placemark: CLPlacemark) {
        self.navigationItem.title = placemark.locality
    }
    
    func displayWeather(placemark: CLPlacemark?, _ weatherDataItems: [WeatherDataItem]?) {
        self.navigationItem.title = placemark?.locality
        self.cachedWeatherDataItems = weatherDataItems
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cachedWeatherDataItems?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 83;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("weatherCell", forIndexPath: indexPath) as WeatherTableViewCell
        
        if let weatherDataItem = self.cachedWeatherDataItems?[indexPath.row] {
            if let weakDayString = weatherDataItem.weakDayString {
                cell.titleLabel.text = weakDayString
            }
            if let conditionString = weatherDataItem.conditionString {
                cell.conditionLabel.text = conditionString
            }
            if let temperatureShortString = weatherDataItem.temperatureShortString {
                cell.temperatureLabel.text = temperatureShortString
            }
        }
        return cell
    }
}

