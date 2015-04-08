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
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var loadingVisible: Bool = false
    
    var currentWeatherDataItem: WeatherDataItem? = nil
    var cachedWeatherDataItems: [UInt: WeatherDataItem] = [:]
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "weatherCell")
        self.tableView.tableFooterView = self.activityIndicator
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.currentWeatherDataItem = nil
        self.cachedWeatherDataItems = [:]
        self.updateView()
        
        if CLLocationManager.isLocationUpdatesAvailable() {
            self.setLoadingVisible(true)
            self.weatherDataModel.weatherForCurrentLocation {(weatherDataItem, error) in
                self.setLoadingVisible(false)
                self.currentWeatherDataItem = weatherDataItem
                self.updateView()
                self.displayError(error)
            }
        }
        
        self.setLoadingVisible(true)
        self.weatherDataModel.weatherForStoredLocations {(weatherDataItems, error) in
            self.setLoadingVisible(false)
            for weatherDataItem in weatherDataItems ?? [] {
                self.addToCache(weatherDataItem)
            }
            self.updateView()
            self.displayError(error)
        }
        
        self.setLoadingVisible(true)
        self.weatherDataModel.weatherForNewlyStoredLocation {(weatherDataItem, error) in
            self.setLoadingVisible(false)
            self.addToCache(weatherDataItem)
            self.updateView()
            self.displayError(error)
        }
    }
    
    func setLoadingVisible(visible: Bool) {
        struct Static {
            static var numVisible = 0
        }
        if visible {
            Static.numVisible += 1
        } else if Static.numVisible > 0 {
            Static.numVisible -= 1
        }
        self.activityIndicator.hidden = Static.numVisible == 0
    }
    
    func addToCache(weatherDataItem: WeatherDataItem?) -> Void {
        if let locationId = weatherDataItem?.locationId {
            self.cachedWeatherDataItems[locationId] = weatherDataItem!
        }
    }
    
    func updateView() {
        self.tableView.reloadData()
    }
    
    func attributedStringWithArrow(string: String) -> NSAttributedString {
        let attachement = NSTextAttachment()
        attachement.image = UIImage(named: "Arrow")
        let attachementString = NSAttributedString(attachment: attachement)
        let attributedString = NSMutableAttributedString(string: string + " ")
        attributedString.appendAttributedString(attachementString)
        return attributedString as NSAttributedString
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return CLLocationManager.isLocationUpdatesAvailable() ? 1 : 0
        } else {
            return self.weatherDataModel.locations.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 83;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("weatherCell", forIndexPath: indexPath) as WeatherTableViewCell
        
        var weatherDataItem: WeatherDataItem? = nil
        
        if indexPath.section == 0 {
            weatherDataItem = self.currentWeatherDataItem
            if let name = weatherDataItem?.locationName {
                cell.titleLabel.attributedText = self.attributedStringWithArrow(name)
            }
        } else {
            let locationItem = self.weatherDataModel.locations[indexPath.row]
            cell.titleLabel.text = locationItem.name
            weatherDataItem = self.cachedWeatherDataItems[locationItem.weatherApiId]
        }
        
        if let conditionString = weatherDataItem?.conditionString {
            cell.conditionLabel.text = conditionString
        }
        
        if let temperatureString = weatherDataItem?.temperatureShortString {
            cell.temperatureLabel.text = temperatureString
        }
        
        if let image = weatherDataItem?.image {
            cell.weatherImageView.image = image
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.weatherDataModel.selectedLocationIndex = indexPath.section == 0 ? nil : indexPath.row
        self.performSegueWithIdentifier("dismissLocation", sender: self)
    }
}
