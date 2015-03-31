//
//  WeatherDataModel.swift
//  Weather
//
//  Created by Ondřej Štoček on 28.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

class WeatherDataModel: NSObject {
    
    let numberOfForecastedDays: UInt = 6
    lazy var weatherApi = WeatherApi(apiId: "3b9e5a5284eaa6be66f5cceb016b5471")
    lazy var locationManager = CLLocationManager.updateManagerWithAccuracy(kCLLocationAccuracyHundredMeters, locationAge: 15.0, authorizationDesciption: .WhenInUse)
    
    var temperatureUnit: String {
        get {
            return self.weatherApi.units == .Metric ? "°C" : "°F"
        }
    }
    
    var speedUnit: String {
        get {
            return self.weatherApi.units == .Metric ? "m/s" : "ft/s"
        }
    }
    
    private func currentLocation(callback: (String?, NSError?) -> Void) {
        self.locationManager.startUpdatingLocationWithUpdateBlock { (manager, location, error, stopUpdating) -> Void in
            if let location = location {
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                    if let placemark = placemarks[0] as? CLPlacemark {
                        let location = "\(placemark.locality),\(placemark.ISOcountryCode)"
                        callback(location, error)
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
    
    func weatherForLocation(location: String, callback: (JSON?, NSError?) -> Void) {
        self.weatherApi.currentWeatherByCityName(location, callback)
    }
    
    func weatherForCurrentLocation(callback: (JSON?, NSError?) -> Void) {
        self.currentLocation { (location, error) -> Void in
            if let location = location {
                self.weatherForLocation(location, callback)
            } else {
                callback(nil, error);
            }
        }
    }
    
    func forecastForLocation(location: String, callback: (JSON?, NSError?) -> Void) {
        self.weatherApi.dailyForecastWeatherByCityName(location, forDays: numberOfForecastedDays, callback)
    }
    
    func forecastForCurrentLocation(callback: (JSON?, NSError?) -> Void) {
        self.currentLocation { (location, error) -> Void in
            if let location = location {
                self.forecastForLocation(location, callback)
            } else {
                callback(nil, error)
            }
        }
    }
    
    func weatherForStoredLocations(() -> Void) {
        println("weather for stored locations")
    }
    
    func forecastForCurrentLocation(() -> Void) {
        println("forecast for current location")
    }
}
