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
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
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
    
    // MARK: - Weather
    
    func weatherForSelectedLocation(callback: (WeatherDataItem?, NSError?) -> Void) {
        if let location = self.selectedLocation {
            self.weatherForLocation(location, callback: callback)
        } else {
            self.weatherForCurrentLocation(callback)
        }
    }
    
    func weatherForLocation(location: LocationDataItem, callback: (WeatherDataItem?, NSError?) -> Void) {
        if location.weatherApiId > 0 {
            self.weatherForLocationsWithId([location]) {(weatherDataItems, error) in
                callback(weatherDataItems?[0], error)
            }
        } else {
            let locationString = "\(location.name),\(location.isoCountryCode)"
            self.communicator.currentWeatherForLocation(locationString) {(json, error) in
                var weatherDataItem: WeatherDataItem?
                if let json = json {
                    weatherDataItem = WeatherDataItem(json, location: location)
                    if let locationId = weatherDataItem?.locationId {
                        location.weatherApiId = locationId
                        self.locationCoreDataModel?.saveContext()
                    }
                }
                callback(weatherDataItem, error)
            }
        }
    }
    
    func weatherForLocationsWithId(locations: [LocationDataItem], callback: ([WeatherDataItem]?, NSError?) -> Void) {
        let locationIds = locations.filter({
            $0.weatherApiId > 0
        }).map({
            $0.weatherApiId
        })
        
        if locationIds.count > 0 {
            self.communicator.currentWeatherForLocationIds(locationIds) {(json, error) in
                var weatherDataItems: [WeatherDataItem]? = nil
                if let json = json {
                    for (index, subjson) in enumerate(json["list"].arrayValue) {
                        weatherDataItems = (weatherDataItems ?? []) + [WeatherDataItem(subjson, location: locations[index])]
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
        self.weatherForLocationsWithId(self.locations, callback: callback)
    }
    
    func weatherForNewlyStoredLocation(callback: (WeatherDataItem?, NSError?) -> Void) {
        if let location = self.locations.filter({$0.weatherApiId == 0}).first {
            self.weatherForLocation(location, callback: callback)
        } else {
            callback(nil, nil)
        }
    }
    
    // MARK: - Forecast
    
    func forecastForSelectedLocation(callback: ([WeatherDataItem]?, NSError?) -> Void) {
        if let location = self.selectedLocation {
            self.forecastForLocation(location, callback: callback)
        } else {
            self.forecastForCurrentLocation(callback)
        }
    }
    
    func forecastForLocation(location: LocationDataItem, callback: ([WeatherDataItem]?, NSError?) -> Void) {
        if location.weatherApiId > 0 {
            self.communicator.dailyForecastWeatherForLocationId(location.weatherApiId, forDays: self.numberOfForecastedDays) {(json, error) in
                var weatherDataItems: [WeatherDataItem]? = nil
                if let json = json {
                    for subjson in json["list"].arrayValue {
                        weatherDataItems = (weatherDataItems ?? []) + [WeatherDataItem(subjson, location: location)]
                    }
                }
                callback(weatherDataItems, error)
            }
        } else {
            let locationString = "\(location.name),\(location.isoCountryCode)"
            self.communicator.dailyForecastWeatherForLocation(locationString, forDays: self.numberOfForecastedDays) {(json, error) in
                var weatherDataItems: [WeatherDataItem]? = nil
                if let json = json {
                    for subjson in json["list"].arrayValue {
                        weatherDataItems = (weatherDataItems ?? []) + [WeatherDataItem(subjson, location: location)]
                    }
                    if let locationId = weatherDataItems?[0].locationId {
                        location.weatherApiId = locationId
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
    
    var selectedLocationIndex: Int? {
        get {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let number = userDefaults.objectForKey("selectedLocationIndex") as! NSNumber?
            return number?.integerValue
        }
        set(index) {
            let number: NSNumber? = index != nil ? NSNumber(long: index!) : nil
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(number, forKey: "selectedLocationIndex")
        }
    }
    
    func addLocationWithName(name: String, country: String, countryCode: String) {
        self.locationCoreDataModel?.newItemWithName(name, country: country, countryCode: countryCode)
    }
    
    func deleteLocationAtIndex(index: Int) {
        self.deleteLocation(self.locations[index])
        if index == self.selectedLocationIndex {
            self.selectedLocationIndex = nil
        }
    }
    
    func deleteLocation(location: LocationDataItem) {
        self.locationCoreDataModel?.deleteItem(location)
    }
    
    var locations: [LocationDataItem] {
        return self.locationCoreDataModel?.items ?? []
    }
    
    var selectedLocation: LocationDataItem? {
        if let index = self.selectedLocationIndex {
            return self.locations[index]
        }
        return nil
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
