//
//  LocationTableViewController.swift
//  Weather
//
//  Created by Ondřej Štoček on 21.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var cachedCurrentLocation: (placemark: CLPlacemark?, weatherDataItem: WeatherDataItem?)?
    var cachedWeatherDataItems: [UInt: WeatherDataItem] = [:]
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "weatherCell")
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshWeather()
        
        self.weatherDataModel.weatherForCurrentLocation {(placemark, weatherDataItem, error) in
            self.cachedCurrentLocation = (placemark: placemark, weatherDataItem: weatherDataItem)
            self.refreshWeather()
            self.displayError(error)
        }
        
        self.weatherDataModel.weatherForStoredLocations {(weatherDataItems, error) in
            for weatherDataItem in weatherDataItems ?? [] {
                self.addToCache(weatherDataItem)
            }
            self.refreshWeather()
            self.displayError(error)
        }
        
        self.weatherDataModel.weatherForNewlyStoredLocation {(weatherDataItem, error) in
            self.addToCache(weatherDataItem)
            self.refreshWeather()
            self.displayError(error)
        }
    }
    
    func addToCache(weatherDataItem: WeatherDataItem?) -> Void {
        if let locationId = weatherDataItem?.locationId {
            self.cachedWeatherDataItems[locationId] = weatherDataItem!
        }
    }
    
    func refreshWeather() {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.weatherDataModel.locations.count
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 83;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("weatherCell", forIndexPath: indexPath) as WeatherTableViewCell
        
        var locationName: String? = nil
        var weatherDataItem: WeatherDataItem? = nil
        if indexPath.section == 0 {
            if let placemark = self.cachedCurrentLocation?.placemark {
                locationName = placemark.locality
            }
            weatherDataItem = self.cachedCurrentLocation?.weatherDataItem
        } else {
            let locationItem = self.weatherDataModel.locations[indexPath.row]
            locationName = locationItem.name
            weatherDataItem = self.cachedWeatherDataItems[locationItem.weatherApiId]
        }
        
        if let locationName = locationName {
            cell.titleLabel.text = locationName
        }
        
        if let conditionString = weatherDataItem?.conditionString {
            cell.conditionLabel.text = conditionString
        }
        
        if let temperatureString = weatherDataItem?.temperatureShortString {
            cell.temperatureLabel.text = temperatureString
        }
        

        return cell
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section != 0
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.weatherDataModel.deleteLocationAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }    
    }
}
