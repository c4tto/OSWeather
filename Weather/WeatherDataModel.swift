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
    var communicator: WeatherApiCommunicator
    var locationCoreDataModel: LocationCoreDataModel?
    lazy var locationManager = CLLocationManager.updateManagerWithAccuracy(kCLLocationAccuracyHundredMeters, locationAge: 15.0, authorizationDesciption: .WhenInUse)
    
    init(communicator: WeatherApiCommunicator, locationCoreDataModel: LocationCoreDataModel?) {
        self.communicator = communicator
        self.locationCoreDataModel = locationCoreDataModel
        super.init()
    }
    
    var temperatureUnit: String {
        return self.communicator.units == .Metric ? "°C" : "°F"
    }
    
    var speedUnit: String {
        return self.communicator.units == .Metric ? "m/s" : "ft/s"
    }
    
    private func currentLocation(callback: (CLPlacemark?, NSError?) -> Void) {
        self.locationManager.startUpdatingLocationWithUpdateBlock {(manager, location, error, stopUpdating) in
            if let location = location {
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
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
    
    func weatherForCurrentLocation(callback: (CLPlacemark?, WeatherDataItem?, NSError?) -> Void) {
        self.currentLocation {(placemark, error) in
            if let placemark = placemark {
                let location = "\(placemark.locality),\(placemark.ISOcountryCode)"
                self.communicator.currentWeatherForLocation(location) {(json, error) in
                    var weatherDataItem: WeatherDataItem?
                    if let json = json {
                        weatherDataItem = WeatherDataItem(json: json, model: self)
                    }
                    callback(placemark, weatherDataItem, error)
                }
            } else {
                callback(nil, nil, error);
            }
        }
    }
    
    func forecastForCurrentLocation(callback: (CLPlacemark?, [WeatherDataItem]?, NSError?) -> Void) {
        self.currentLocation {(placemark, error) in
            if let placemark = placemark {
                let location = "\(placemark.locality),\(placemark.ISOcountryCode)"
                self.communicator.dailyForecastWeatherForLocation(location, forDays: self.numberOfForecastedDays) {(json, error) in
                    var weatherDataItems: [WeatherDataItem] = []
                    if let json = json {
                        for subjson in json["list"].arrayValue {
                            weatherDataItems.append(WeatherDataItem(json: subjson, model: self))
                        }
                    }
                    callback(placemark, weatherDataItems, error)
                }
            } else {
                callback(nil, nil, error)
            }
        }
    }
    
    func weatherForNewlyStoredLocation(callback: (WeatherDataItem?, NSError?) -> Void) {
        let locationItemsWithoutId = self.locations.filter {$0.weatherApiId == 0}
        if locationItemsWithoutId.count > 0 {
            for locationItem in locationItemsWithoutId {
                let location = "\(locationItem.name),\(locationItem.isoCountryCode)"
                self.communicator.currentWeatherForLocation(location) {(json, error) in
                    var weatherDataItem: WeatherDataItem?
                    if let json = json {
                        weatherDataItem = WeatherDataItem(json: json, model: self)
                        if let locationId = weatherDataItem?.locationId {
                            locationItem.weatherApiId = locationId
                            self.locationCoreDataModel?.saveContext()
                        }
                    }
                    callback(weatherDataItem, error)
                }
            }
        } else {
            callback(nil, nil)
        }
    }
    
    func weatherForStoredLocations(callback: ([WeatherDataItem]?, NSError?) -> Void) {
        let locationIds = self.locations.filter {$0.weatherApiId > 0}.map {$0.weatherApiId}
        if locationIds.count > 0 {
            self.communicator.currentWeatherForLocationIds(locationIds) {(json, error) in
                var weatherDataItems: [WeatherDataItem] = []
                if let json = json {
                    for subjson in json["list"].arrayValue {
                        weatherDataItems.append(WeatherDataItem(json: subjson, model: self))
                    }
                }
                callback(weatherDataItems, error)
            }
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
