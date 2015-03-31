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
    
    var cachedCurrentLocationData: (placemark: CLPlacemark?, json: JSON?)?
    var cachedStoredLocationsJson: JSON?
    var cachedNewlyAddedLocationJson: JSON?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "weatherCell")
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        
        self.weatherDataModel.weatherForCurrentLocation { (placemark, json, error) in
            self.cachedCurrentLocationData = (placemark: placemark, json: json)
            self.tableView.reloadData()
        }
        
        self.weatherDataModel.weatherForStoredLocations { (json, error) in
            self.cachedStoredLocationsJson = json
            self.tableView.reloadData()
        }
        
        self.weatherDataModel.weatherForNewlyStoredLocation { (json, error) in
            self.cachedNewlyAddedLocationJson = json
            self.tableView.reloadData()
        }
    }
    
    func cachedJsonForLocationWithId(locationId: UInt) -> JSON? {
        if let json = self.cachedStoredLocationsJson {
            for subjson in json["list"].arrayValue {
                if subjson["id"].uInt == locationId {
                    return subjson
                }
            }
        }
        if let json = self.cachedNewlyAddedLocationJson {
            if json["id"].uInt == locationId {
                return json
            }
        }
        return nil;
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
        
        if indexPath.section == 0 {
            if let placemark = self.cachedCurrentLocationData?.placemark {
                cell.titleLabel.text = placemark.locality
            }
            if let json = self.cachedCurrentLocationData?.json {
                if let condition = json["weather"][0]["main"].string {
                    cell.conditionLabel.text = condition
                }
                if let temp = json["main"]["temp"].float {
                    cell.temperatureLabel.text = "\(Int(round(temp)))°"
                }
            }
        } else {
            let locationItem = self.weatherDataModel.locations[indexPath.row]
            cell.titleLabel.text = locationItem.name
        
            if let json = self.cachedJsonForLocationWithId(locationItem.weatherApiId) {
                if let condition = json["weather"][0]["main"].string {
                    cell.conditionLabel.text = condition
                }
                if let temp = json["main"]["temp"].float {
                    cell.temperatureLabel.text = "\(Int(round(temp)))°"
                }
            }
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

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
}
