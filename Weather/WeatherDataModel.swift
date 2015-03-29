//
//  WeatherDataModel.swift
//  Weather
//
//  Created by Ondřej Štoček on 28.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

class WeatherDataModel: NSObject {
    override init() {
        super.init()
        
        if CLLocationManager.isLocationUpdatesAvailable() {
            println("location available")
        } else {
            println("UNAVAILABLE")
        }
    }
    
    lazy var weatherApi = WeatherApi(apiId: "3b9e5a5284eaa6be66f5cceb016b5471")
    lazy var locationManager = CLLocationManager.updateManagerWithAccuracy(kCLLocationAccuracyHundredMeters, locationAge: 15.0, authorizationDesciption: .WhenInUse)
    
    private func getCurrentLocation(callback: (CLPlacemark?, NSError?) -> Void) {
        self.locationManager.startUpdatingLocationWithUpdateBlock { (manager, location, error, stopUpdating) -> Void in
            if let location = location {
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                    let placemark = placemarks[0] as CLPlacemark
                    callback(placemark, error)
                })
            } else {
                callback(nil, error)
            }
            stopUpdating.memory = true
        }
    }
    
    func addLocation(locationId: String) {
    }
    
    func weatherForCurrentLocation(callback: (JSON?, NSError?) -> Void) {
        println("weather for current location")
        self.getCurrentLocation {
            (placemark: CLPlacemark?, error: NSError?) -> Void in
            
            if let placemark = placemark {
                let cityName = "\(placemark.locality),\(placemark.ISOcountryCode)"
                
                self.weatherApi.currentWeatherByCityName(cityName) { (json, error) -> Void in
                    callback(json, error)
                }
                
            } else {
                callback(nil, error);
            }
            /*
            if let coordinate = location?.coordinate {
                self.weatherApi.currentWeatherByCoordinate(coordinate, withCallback: {
                    (error: NSError!, result: [NSObject: AnyObject]!) -> Void in
                    
                    callback(result, error)
                })
            } else {
                callback(nil, error)
            }
            */
        }
    }
    
    /*
    func weatherForLocationWithName(locationName: String, callback: ([NSObject: AnyObject]?, NSError?) -> Void) {
        self.weatherApi.weatherByCityName(locationName, withCallback: {
            (error: NSError!, result: [NSObject: AnyObject]!) -> Void in
            callback(result, error)
        })
    }
*/
    
    func weatherForStoredLocations(() -> Void) {
        println("weather for stored locations")
    }
    
    func forecastForCurrentLocation(() -> Void) {
        println("forecast for current location")
    }
}
