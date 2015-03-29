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
    
    // HMPFFF!!!
    private var _weatherApi: OWMWeatherAPI?
    var weatherApi: OWMWeatherAPI {
        get {
            if _weatherApi == nil {
                let weatherApiKey = "3b9e5a5284eaa6be66f5cceb016b5471"
                _weatherApi = OWMWeatherAPI(APIKey: weatherApiKey)
                _weatherApi?.setLangWithPreferedLanguage()
                _weatherApi?.setTemperatureFormat(kOWMTempCelcius)
            }
            return _weatherApi!
        }
    }
    
    private var _locationManager: CLLocationManager?
    var locationManager: CLLocationManager {
        get {
            if _locationManager == nil {
                _locationManager = CLLocationManager.updateManagerWithAccuracy(kCLLocationAccuracyKilometer, locationAge: 15.0, authorizationDesciption: .WhenInUse)
            }
            return _locationManager!
        }
    }
    
    private func getCurrentLocation(callback: (CLPlacemark?, NSError?) -> Void) {
        
        self.locationManager.startUpdatingLocationWithUpdateBlock {
            (manager: CLLocationManager?, location: CLLocation?, error: NSError?,
            stopUpdating: UnsafeMutablePointer<ObjCBool>) -> Void in
            
            if let location = location {
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: {
                    (placemarks: [AnyObject]!, error: NSError!) -> Void in
                    let placemark: CLPlacemark = placemarks[0] as CLPlacemark
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
    
    func weatherForCurrentLocation(callback: ([NSObject: AnyObject]?, NSError?) -> Void) {
        println("weather for current location")
        self.getCurrentLocation {
            (placemark: CLPlacemark?, error: NSError?) -> Void in
            
            if let placemark = placemark {
                let cityName = "\(placemark.locality),\(placemark.ISOcountryCode)"
                self.weatherApi.currentWeatherByCityName(cityName, withCallback: {
                    (error: NSError!, result: [NSObject: AnyObject]!) -> Void in
                    callback(result, error)
                })
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
    
    func weatherForLocationWithName(locationName: String, callback: ([NSObject: AnyObject]?, NSError?) -> Void) {
        self.weatherApi.currentWeatherByCityName(locationName, withCallback: {
            (error: NSError!, result: [NSObject: AnyObject]!) -> Void in
            callback(result, error)
        })
    }
    
    func weatherForStoredLocations(() -> Void) {
        println("weather for stored locations")
    }
    
    func forecastForCurrentLocation(() -> Void) {
        println("forecast for current location")
    }
}
