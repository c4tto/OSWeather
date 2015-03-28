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
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        appDelegate.weatherApi.currentWeatherByCityName("Prague,cz", withCallback: {
            (error: NSError?, result: [NSObject : AnyObject]!) -> Void in
            println("loaded \(result) \(error)")
        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
        parentViewController?.navigationItem.title = "Today"
    }
}

