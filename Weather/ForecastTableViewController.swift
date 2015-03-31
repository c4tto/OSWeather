//
//  ForecastTableViewController.swift
//  Weather
//
//  Created by Ondřej Štoček on 21.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

class ForecastTableViewController: UITableViewController {
    
    var cachedJson: JSON?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "weatherCell")
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.weatherDataModel.forecastForCurrentLocation { (json, error) -> Void in
            if let json = json {
                self.displayWeather(json)
            } else {
                println(error)
            }
        }
    }
    
    func displayWeather(json: JSON) {
        if let city = json["city"]["name"].string {
            self.navigationItem.title = city
        }
        self.cachedJson = json
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cachedJson?["list"].array?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 83;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("weatherCell", forIndexPath: indexPath) as WeatherTableViewCell
        
        if let json = self.cachedJson {
            
            if let timestamp = json["list"][indexPath.row]["dt"].int {
                let date = NSDate(timeIntervalSince1970: NSTimeInterval(timestamp))
                let formatter = NSDateFormatter()
                formatter.locale = NSLocale(localeIdentifier: "en-GB")
                formatter.dateFormat = "EEEE"
                cell.titleLabel.text = formatter.stringFromDate(date)
            }
            
            if let weatherDesc = json["list"][indexPath.row]["weather"][0]["main"].string {
                cell.conditionLabel.text = weatherDesc
            }
            
            if let temp = json["list"][indexPath.row]["temp"]["day"].float {
                cell.temparatureLabel.text = "\(Int(round(temp)))°"
            }
        }
        return cell
    }
}

