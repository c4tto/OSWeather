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
    
    var selectedLocationIndex: Int? = nil
    let numberOfForecastedDays: UInt = 6
    var communicator: WeatherApiCommunicator
    var locationCoreDataModel: LocationCoreDataModel?
    lazy var locationManager = LocationManager()
    
    init(communicator: WeatherApiCommunicator, locationCoreDataModel: LocationCoreDataModel?) {
        self.communicator = communicator
        self.locationCoreDataModel = locationCoreDataModel
        super.init()
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
    
    func weatherForLocationItem(locationItem: LocationItem, callback: (WeatherDataItem?, NSError?) -> Void) {
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
    
    func weatherForLocationItemsWithId(locationItems: [LocationItem], callback: ([WeatherDataItem]?, NSError?) -> Void) {
        let locationIds = locationItems.filter({
            $0.weatherApiId > 0
        }).map({
            $0.weatherApiId
        })
        
        if locationIds.count > 0 {
            self.communicator.currentWeatherForLocationIds(locationIds) {(json, error) in
                var weatherDataItems: [WeatherDataItem] = []
                if let json = json {
                    for (index, subjson) in enumerate(json["list"].arrayValue) {
                        weatherDataItems.append(WeatherDataItem(subjson, locationItem: locationItems[index]))
                    }
                }
                callback(weatherDataItems, error)
            }
        } else {
            callback([], nil)
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
    
    func forecastForLocationItem(locationItem: LocationItem, callback: ([WeatherDataItem]?, NSError?) -> Void) {
        if locationItem.weatherApiId > 0 {
            self.communicator.dailyForecastWeatherForLocationId(locationItem.weatherApiId, forDays: self.numberOfForecastedDays) {(json, error) in
                var weatherDataItems: [WeatherDataItem] = []
                if let json = json {
                    for subjson in json["list"].arrayValue {
                        weatherDataItems.append(WeatherDataItem(subjson, locationItem: locationItem))
                    }
                }
                callback(weatherDataItems, error)
            }
        } else {
            let location = "\(locationItem.name),\(locationItem.isoCountryCode)"
            self.communicator.dailyForecastWeatherForLocation(location, forDays: self.numberOfForecastedDays) {(json, error) in
                var weatherDataItems: [WeatherDataItem] = []
                if let json = json {
                    for subjson in json["list"].arrayValue {
                        weatherDataItems.append(WeatherDataItem(subjson, locationItem: locationItem))
                    }
                }
                // FIXME: add weatherApiId to LocationItem
                callback(weatherDataItems, error)
            }
        }
    }
    
    func forecastForCurrentLocation(callback: ([WeatherDataItem]?, NSError?) -> Void) {
        self.locationManager.currentLocation {(placemark, error) in
            if let placemark = placemark {
                let location = "\(placemark.locality),\(placemark.ISOcountryCode)"
                self.communicator.dailyForecastWeatherForLocation(location, forDays: self.numberOfForecastedDays) {(json, error) in
                    var weatherDataItems: [WeatherDataItem] = []
                    if let json = json {
                        for (index, subjson) in enumerate(json["list"].arrayValue) {
                            weatherDataItems.append(WeatherDataItem(subjson, placemark: placemark))
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
    
    func deleteLocation(locationItem: LocationItem) {
        self.locationCoreDataModel?.deleteItem(locationItem)
    }
    
    var locations: [LocationItem] {
        return self.locationCoreDataModel?.items ?? []
    }
}
