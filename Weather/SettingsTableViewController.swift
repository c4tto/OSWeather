//
//  SettingsTableViewController.swift
//  Weather
//
//  Created by Ondřej Štoček on 21.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet var lengthCell: UITableViewCell!
    @IBOutlet var temperatureCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        lengthCell.detailTextLabel?.text = WeatherDataItem.lengthUnit.rawValue
        temperatureCell.detailTextLabel?.text = WeatherDataItem.temperatureUnit.rawValue
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if cell == lengthCell {
            WeatherDataItem.lengthUnit = WeatherDataItem.lengthUnit == .Metric ? .Imperial : .Metric
            userDefaults.setObject(WeatherDataItem.lengthUnit.rawValue, forKey: "lengthUnit")
            lengthCell.detailTextLabel?.text = WeatherDataItem.lengthUnit.rawValue
        } else if cell == temperatureCell {
            WeatherDataItem.temperatureUnit = WeatherDataItem.temperatureUnit == .Celsius ? .Fahrenheit : .Celsius
            userDefaults.setObject(WeatherDataItem.temperatureUnit.rawValue, forKey: "temperatureUnit")
            temperatureCell.detailTextLabel?.text = WeatherDataItem.temperatureUnit.rawValue
        }
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
