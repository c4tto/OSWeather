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
    lazy var locationManager = CurrentLocationManager()
    
    init(communicator: WeatherApiCommunicator, locationCoreDataModel: LocationCoreDataModel?) {
        self.communicator = communicator
        self.locationCoreDataModel = locationCoreDataModel
        super.init()
    }
    
    var selectedLocationIndex: Int? {
        get {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let number = userDefaults.objectForKey("selectedLocationIndex") as NSNumber?
            return number?.integerValue
        }
        set(index) {
            let number: NSNumber? = index != nil ? NSNumber(long: index!) : nil
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(number, forKey: "selectedLocationIndex")
        }
    }
    
    // MARK: - Weather
    
    func weatherForSelectedLocation(callback: (WeatherDataItem?, NSError?) -> Void) {
        if let index = self.selectedLocationIndex {
            let item = self.locations[index]
            self.weatherForLocationItem(item, callback)
        } else {
            self.weatherForCurrentLocation(callback)
        }
    }
    
    func weatherForLocationItem(locationItem: LocationDataItem, callback: (WeatherDataItem?, NSError?) -> Void) {
        if locationItem.weatherApiId > 0 {
            self.weatherForLocationItemsWithId([locationItem]) {(weatherDataItems, error) in
                callback(weatherDataItems?[0], error)
            }
        } else {
            let location = "\(locationItem.name),\(locationItem.isoCountryCode)"
            self.communicator.currentWeatherForLocation(location) {(json, error) in
                var weatherDataItem: WeatherDataItem?
                if let json = json {
                    weatherDataItem = WeatherDataItem(json, locationItem: locationItem)
                    if let locationId = weatherDataItem?.locationId {
                        locationItem.weatherApiId = locationId
                        self.locationCoreDataModel?.saveContext()
                    }
                }
                callback(weatherDataItem, error)
            }
        }
    }
    
    func weatherForLocationItemsWithId(locationItems: [LocationDataItem], callback: ([WeatherDataItem]?, NSError?) -> Void) {
        let locationIds = locationItems.filter({
            $0.weatherApiId > 0
        }).map({
            $0.weatherApiId
        })
        
        if locationIds.count > 0 {
            self.communicator.currentWeatherForLocationIds(locationIds) {(json, error) in
                var weatherDataItems: [WeatherDataItem]? = nil
                if let json = json {
                    for (index, subjson) in enumerate(json["list"].arrayValue) {
                        weatherDataItems = (weatherDataItems ?? []) + [WeatherDataItem(subjson, locationItem: locationItems[index])]
                    }
                }
                callback(weatherDataItems, error)
            }
        } else {
            callback(nil, nil)
        }
    }
    
    func weatherForCurrentLocation(callback: (WeatherDataItem?, NSError?) -> Void) {
        self.locationManager.currentLocation {(placemark, error) in
            if let placemark = placemark {
                let location = "\(placemark.locality),\(placemark.ISOcountryCode)"
                self.communicator.currentWeatherForLocation(location) {(json, error) in
                    var weatherDataItem: WeatherDataItem?
                    if let json = json {
                        weatherDataItem = WeatherDataItem(json, placemark: placemark)
                    }
                    callback(weatherDataItem, error)
                }
            } else {
                callback(nil, error);
            }
        }
    }
    
    func weatherForStoredLocations(callback: ([WeatherDataItem]?, NSError?) -> Void) {
        self.weatherForLocationItemsWithId(self.locations, callback: callback)
    }
    
    func weatherForNewlyStoredLocation(callback: (WeatherDataItem?, NSError?) -> Void) {
        if let locationItem = self.locations.filter({$0.weatherApiId == 0}).first {
            self.weatherForLocationItem(locationItem, callback: callback)
        } else {
            callback(nil, nil)
        }
    }
    
    // MARK: - Forecast
    
    func forecastForSelectedLocation(callback: ([WeatherDataItem]?, NSError?) -> Void) {
        if let index = self.selectedLocationIndex {
            let item = self.locations[index]
            self.forecastForLocationItem(item, callback)
        } else {
            self.forecastForCurrentLocation(callback)
        }
    }
    
    func forecastForLocationItem(locationItem: LocationDataItem, callback: ([WeatherDataItem]?, NSError?) -> Void) {
        if locationItem.weatherApiId > 0 {
            self.communicator.dailyForecastWeatherForLocationId(locationItem.weatherApiId, forDays: self.numberOfForecastedDays) {(json, error) in
                var weatherDataItems: [WeatherDataItem]? = nil
                if let json = json {
                    for subjson in json["list"].arrayValue {
                        weatherDataItems = (weatherDataItems ?? []) + [WeatherDataItem(subjson, locationItem: locationItem)]
                    }
                }
                callback(weatherDataItems, error)
            }
        } else {
            let location = "\(locationItem.name),\(locationItem.isoCountryCode)"
            self.communicator.dailyForecastWeatherForLocation(location, forDays: self.numberOfForecastedDays) {(json, error) in
                var weatherDataItems: [WeatherDataItem]? = nil
                if let json = json {
                    for subjson in json["list"].arrayValue {
                        weatherDataItems = (weatherDataItems ?? []) + [WeatherDataItem(subjson, locationItem: locationItem)]
                    }
                    if let locationId = weatherDataItems?[0].locationId {
                        locationItem.weatherApiId = locationId
                        self.locationCoreDataModel?.saveContext()
                    }
                }
                callback(weatherDataItems, error)
            }
        }
    }
    
    func forecastForCurrentLocation(callback: ([WeatherDataItem]?, NSError?) -> Void) {
        self.locationManager.currentLocation {(placemark, error) in
            if let placemark = placemark {
                let location = "\(placemark.locality),\(placemark.ISOcountryCode)"
                self.communicator.dailyForecastWeatherForLocation(location, forDays: self.numberOfForecastedDays) {(json, error) in
                    var weatherDataItems: [WeatherDataItem]? = nil
                    if let json = json {
                        for (index, subjson) in enumerate(json["list"].arrayValue) {
                            weatherDataItems = (weatherDataItems ?? []) + [WeatherDataItem(subjson, placemark: placemark)]
                        }
                    }
                    callback(weatherDataItems, error)
                }
            } else {
                callback(nil, error)
            }
        }
    }
    
    // MARK: - Stored locations management
    
    func addLocationWithName(name: String, country: String, countryCode: String) {
        self.locationCoreDataModel?.newItemWithName(name, country: country, countryCode: countryCode)
    }
    
    func deleteLocationAtIndex(index: Int) {
        self.deleteLocation(self.locations[index])
        if index == self.selectedLocationIndex {
            self.selectedLocationIndex = nil
        }
    }
    
    func deleteLocation(locationItem: LocationDataItem) {
        self.locationCoreDataModel?.deleteItem(locationItem)
    }
    
    var locations: [LocationDataItem] {
        return self.locationCoreDataModel?.items ?? []
    }
    
    // MARK: -
    func descriptionForError(error: NSError) -> String {
        if error.domain == kCLErrorDomain {
            return "Current location detection is not available."
        } else {
            return error.localizedDescription
        }
    }
}
