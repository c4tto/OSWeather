//
//  WeatherDataModel.swift
//  Weather
//
//  Created by Ondřej Štoček on 28.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

extension UIViewController {
    var weatherDataModel: WeatherDataModel {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        return appDelegate.weatherDataModel
    }
}

class WeatherDataModel: NSObject {
    
    let numberOfForecastedDays: UInt = 6
    var weatherApi: WeatherApi
    var locationCoreDataModel: LocationCoreDataModel?
    lazy var locationManager = CLLocationManager.updateManagerWithAccuracy(kCLLocationAccuracyHundredMeters, locationAge: 15.0, authorizationDesciption: .WhenInUse)
    
    init(weatherApi: WeatherApi, locationCoreDataModel: LocationCoreDataModel?) {
        self.weatherApi = weatherApi
        self.locationCoreDataModel = locationCoreDataModel
        super.init()
    }
    
    var temperatureUnit: String {
        return self.weatherApi.units == .Metric ? "°C" : "°F"
    }
    
    var speedUnit: String {
        return self.weatherApi.units == .Metric ? "m/s" : "ft/s"
    }
    
    private func currentLocation(callback: (CLPlacemark?, NSError?) -> Void) {
        self.locationManager.startUpdatingLocationWithUpdateBlock { (manager, location, error, stopUpdating) -> Void in
            if let location = location {
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                    if let placemark = placemarks[0] as? CLPlacemark {
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
    
    func weatherForLocation(location: String, callback: (JSON?, NSError?) -> Void) {
        self.weatherApi.currentWeatherByCityName(location, callback)
    }
    
    func weatherForCurrentLocation(callback: (CLPlacemark?, JSON?, NSError?) -> Void) {
        self.currentLocation { (placemark, error) -> Void in
            if let placemark = placemark {
                let location = "\(placemark.locality),\(placemark.ISOcountryCode)"
                self.weatherForLocation(location) { (json, error) -> Void in
                    callback(placemark, json, error)
                }
            } else {
                callback(nil, nil, error);
            }
        }
    }
    
    func forecastForLocation(location: String, callback: (JSON?, NSError?) -> Void) {
        self.weatherApi.dailyForecastWeatherByCityName(location, forDays: self.numberOfForecastedDays, callback)
    }
    
    func forecastForCurrentLocation(callback: (CLPlacemark?, JSON?, NSError?) -> Void) {
        self.currentLocation { (placemark, error) -> Void in
            if let placemark = placemark {
                let location = "\(placemark.locality),\(placemark.ISOcountryCode)"
                self.forecastForLocation(location) { (json, error) -> Void in
                    callback(placemark, json, error)
                }
            } else {
                callback(nil, nil, error)
            }
        }
    }
    
    func weatherForStoredLocations((JSON?, NSError?) -> Void) {
        println("weather for stored locations")
    }
    
    func addLocationWithName(name: String, country: String, countryCode: String) {
        self.locationCoreDataModel?.newItemWithName(name, country: country, countryCode: countryCode)
    }
    
    func deleteLocationAtIndex(index: Int) {
        self.deleteLocation(self.locations[index])
    }
    
    func deleteLocation(locationItem: LocationItem) {
        self.locationCoreDataModel?.deleteItem(locationItem)
    }
    
    var locations: [LocationItem] {
        return self.locationCoreDataModel?.items ?? []
    }
}
