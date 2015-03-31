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
    
    func weatherForCurrentLocation(callback: (CLPlacemark?, JSON?, NSError?) -> Void) {
        self.currentLocation { (placemark, error) in
            if let placemark = placemark {
                let location = "\(placemark.locality),\(placemark.ISOcountryCode)"
                self.weatherApi.currentWeatherForLocation(location) { (json, error) in
                    callback(placemark, json, error)
                }
            } else {
                callback(nil, nil, error);
            }
        }
    }
    
    func forecastForCurrentLocation(callback: (CLPlacemark?, JSON?, NSError?) -> Void) {
        self.currentLocation { (placemark, error) -> Void in
            if let placemark = placemark {
                let location = "\(placemark.locality),\(placemark.ISOcountryCode)"
                self.weatherApi.dailyForecastWeatherForLocation(location, forDays: self.numberOfForecastedDays) { (json, error) in
                    callback(placemark, json, error)
                }
            } else {
                callback(nil, nil, error)
            }
        }
    }
    
    func weatherForNewlyStoredLocation(callback: (JSON?, NSError?) -> Void) {
        let locationItemsWithoutId = self.locations.filter {$0.weatherApiId == 0}
        if locationItemsWithoutId.count > 0 {
            for locationItem in locationItemsWithoutId {
                let location = "\(locationItem.name),\(locationItem.isoCountryCode)"
                self.weatherApi.currentWeatherForLocation(location) { (json, error) in
                    if let json = json {
                        if let locationId = json["id"].uInt {
                            locationItem.weatherApiId = locationId
                            self.locationCoreDataModel?.saveContext()
                        }
                    }
                    callback(json, error)
                }
            }
        } else {
            callback(nil, nil)
        }
    }
    
    func weatherForStoredLocations(callback: (JSON?, NSError?) -> Void) {
        let locationIds = self.locations.filter {$0.weatherApiId > 0}.map {$0.weatherApiId}
        if locationIds.count > 0 {
            self.weatherApi.currentWeatherForLocationIds(locationIds, callback)
        } else {
            callback(nil, nil)
        }
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
