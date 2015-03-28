//
//  FirstViewController.swift
//  Weather
//
//  Created by Ondřej Štoček on 21.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let locationId: String? = nil
        self.loadWeather(locationId) {
            (result, error) -> Void in
            println(result)
        }
    }
    
    func loadWeather(locationId: String?, callback: ([NSObject: AnyObject]?, NSError?) -> Void) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let id = locationId {
            appDelegate.weatherDataModel.weatherForLocationWithId(id, callback)
        } else {
            appDelegate.weatherDataModel.weatherForCurrentLocation(callback)
        }
    }
}

