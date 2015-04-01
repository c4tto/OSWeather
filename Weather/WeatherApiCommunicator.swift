//
//  WeatherApi.swift
//  Weather
//
//  Created by Ondřej Štoček on 29.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

enum WeatherApiUnits {
    case Internal
    case Metric
    case Imperial
}

class WeatherApiCommunicator: NSObject {
    
    let manager = AFHTTPRequestOperationManager()
    let baseUrl = "http://api.openweathermap.org/data"
    let apiVersion = "2.5"
    let apiId: String
    
    var language: String?
    
    var units: WeatherApiUnits = .Internal
    
    var cache: [String: (date: NSDate, json: JSON)] = [:]
    var cacheExpirationInterval: NSTimeInterval = 10 * 60
    
    init(apiId: String) {
        self.apiId = apiId
        super.init()
    }
    
    var langUrlString: String {
        return language != nil ? "&lang=\(language)" : ""
    }
    
    var unitsUrlString: String {
        switch self.units {
        case .Metric:
            return "&units=metric"
        case .Imperial:
            return "&units=imperial"
        default:
            return ""
        }
    }
    
    var apiIdUrlString: String {
        return "&APPIID=\(apiId)"
    }
    
    func sendRequest(request: String, callback: (JSON?, NSError?) -> Void) {
        let url = "\(baseUrl)/\(apiVersion)/\(request)\(langUrlString)\(unitsUrlString)\(apiIdUrlString)"
        let asciiData = url.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        let nsString = NSString(data: asciiData!, encoding: NSASCIIStringEncoding);
        let escapedUrl = nsString!.stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)!
        
        if let cachedResult = self.cache[url] {
            if cachedResult.date.timeIntervalSinceNow > -self.cacheExpirationInterval {
                callback(cachedResult.json, nil)
                return
            }
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        println(url)
        manager.GET(escapedUrl, parameters: nil,
            success: {(operation: AFHTTPRequestOperation!, response: AnyObject?) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
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
            }, failure: {(operation: AFHTTPRequestOperation!, error: NSError?) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                callback(nil, error)
            })
    }
    
    func currentWeatherForLocation(location: String, callback: (JSON?, NSError?) -> Void) {
        let request = "weather?q=\(location)"
        sendRequest(request, callback: callback);
    }
    
    func currentWeatherForLocationIds(locationIds: [UInt], callback: (JSON?, NSError?) -> Void) {
        let idString = ",".join(locationIds.map {id in id.description})
        let request = "group?id=\(idString)"
        sendRequest(request, callback: callback)
    }
    
    func dailyForecastWeatherForLocation(location: String, forDays days: UInt, callback: (JSON?, NSError?) -> Void) {
        let request = "forecast/daily?q=\(location)&cnt=\(days)"
        sendRequest(request, callback: callback)
    }
}
