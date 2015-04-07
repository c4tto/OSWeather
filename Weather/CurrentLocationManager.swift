//
//  LocationManager.swift
//  Weather
//
//  Created by Ondřej Štoček on 07.04.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

class CurrentLocationManager: NSObject {
    var cachedLocation: (date: NSDate, placemark: CLPlacemark)?
    var cacheExpirationInterval: NSTimeInterval = 10 * 60
    
    lazy var locationManager = CLLocationManager.updateManagerWithAccuracy(kCLLocationAccuracyHundredMeters, locationAge: 15.0, authorizationDesciption: .WhenInUse)
    
    func currentLocation(callback: (CLPlacemark?, NSError?) -> Void) {
        if let cachedLocation = self.cachedLocation {
            if cachedLocation.date.timeIntervalSinceNow > -self.cacheExpirationInterval {
                callback(cachedLocation.placemark, nil)
                return
            }
        }
        
        self.locationManager.startUpdatingLocationWithUpdateBlock {(manager, location, error, stopUpdating) in
            if let location = location {
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
                    if let placemark = placemarks?[0] as? CLPlacemark {
                        self.cachedLocation = (date: NSDate(), placemark: placemark)
                        callback(placemark, error)
                    } else {
                        callback(nil, error)
                    }
                })
            } else {
                callback(nil, error)
            }
            stopUpdating.memory = true
        }
    }

}
