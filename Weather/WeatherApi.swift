//
//  WeatherApi.swift
//  Weather
//
//  Created by Ondřej Štoček on 29.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

enum WeatherApiUnits {
    case Metric
    case Imperial
}

class WeatherApi: NSObject {
    
    let manager = AFHTTPRequestOperationManager()
    let baseUrl = "http://api.openweathermap.org/data"
    let apiVersion = "2.5"
    let apiId: String
    
    var language: String?
    
    var units: WeatherApiUnits = .Metric
    
    var cache: [String: (date: NSDate, json: JSON)] = [:]
    var cacheExpirationInterval: NSTimeInterval = 10 * 60
    
    init(apiId: String) {
        self.apiId = apiId
        super.init()
    }
    
    func sendRequest(request: String, callback: (JSON?, NSError?) -> Void) {
        let langString = language != nil ? "&lang=\(language)" : ""
        let unitsString = units == .Metric ? "&units=metric" : "&units=imperial"
        let url = "\(baseUrl)/\(apiVersion)/\(request)\(langString)\(unitsString)&APPIID=\(apiId)"
        
        if let cachedResult = self.cache[url] {
            if cachedResult.date.timeIntervalSinceNow > -self.cacheExpirationInterval {
                callback(cachedResult.json, nil)
                return
            }
        }
        
        println(url)
        manager.GET(url, parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, response: AnyObject?) -> Void in
                println(response?.description)
                if let response: AnyObject = response {
                    let json = JSON(response)
                    self.cache[url] = (date: NSDate(), json)
                    callback(json, nil)
                } else {
                    let error = NSError(domain: "WeatherLocalErrorDomain", code: -1, userInfo: [
                        NSLocalizedDescriptionKey: "No HTTP response available"
                    ])
                    callback(nil, error)
                }
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError?) -> Void in
                callback(nil, error)
            })
    }
    
    func currentWeatherForLocation(location: String, callback: (JSON?, NSError?) -> Void) {
        let request = "weather?q=\(location)"
        sendRequest(request, callback: callback);
    }
    
    func dailyForecastWeatherForLocation(location: String, forDays days: UInt, callback: (JSON?, NSError?) -> Void) {
        let request = "forecast/daily?q=\(location)&cnt=\(days)"
        sendRequest(request, callback: callback)
    }
}
