//
//  ForecastTableViewController.swift
//  Weather
//
//  Created by Ondřej Štoček on 21.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

class ForecastTableViewController: UITableViewController {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var errorLabel: UILabel!
    
    var weatherDataItems: [WeatherDataItem]?
    var error: NSError?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: "weatherCell")
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.weatherDataItems = nil
        self.error = nil
        self.updateView()
        
        self.weatherDataModel.forecastForSelectedLocation {(weatherDataItems, error) in
            self.weatherDataItems = weatherDataItems
            self.error = error
            self.updateView()
        }
    }
    
    func updateView() {
        if let weatherDataItems = self.weatherDataItems {
            self.tableView.backgroundView = nil
            self.navigationItem.title = weatherDataItems[0].locationName
        } else if let error = self.error {
            self.navigationItem.title = nil
            self.errorLabel.text = self.weatherDataModel.descriptionForError(error)
            self.errorLabel.sizeToFit()
            self.tableView.backgroundView = self.errorLabel
        } else {
            self.navigationItem.title = nil
            self.tableView.backgroundView = self.activityIndicator
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

