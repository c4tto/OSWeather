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
    
    init(apiId: String) {
        self.apiId = apiId
        super.init()
    }
    
    func sendRequest(request: String, callback: (JSON?, NSError?) -> Void) {
        let langString = language != nil ? "&lang=\(language)" : ""
        let unitsString = units == .Metric ? "&units=metric" : "&units=imperial"
        let url = "\(baseUrl)/\(apiVersion)/\(request)&APPIID=\(apiId)\(langString)\(unitsString)"
        manager.GET(url, parameters: nil,
            success: { (operation, response) -> Void in
                println(response.description)
                callback(JSON(response), nil)
            }, failure: { (operation, error) -> Void in
                callback(nil, error)
            })
    }
    
    func currentWeatherByCityName(cityName: String, callback: (JSON?, NSError?) -> Void) {
        let request = "weather?q=\(cityName)"
        sendRequest(request, callback: callback);
    }
    
    func currentWeatherByCityId(cityId: String, callback: (JSON?, NSError?) -> Void) {
        let request = "weather?id=\(cityId)"
        sendRequest(request, callback: callback);
    }
    
    func currentWeatherByCoordinate(coord: CLLocationCoordinate2D, callback: (JSON?, NSError?) -> Void) {
        let request = "weather?lat=\(coord.latitude)&lon=\(coord.longitude)"
        sendRequest(request, callback: callback)
    }
    
    func forecastWeatherByCityName(cityName: String, callback: (JSON?, NSError?) -> Void) {
        let request = "forecast?q=\(cityName)"
        sendRequest(request, callback: callback)
    }
    
    func forecastWeatherByCityId(cityId: String, callback: (JSON?, NSError?) -> Void) {
        let request = "forecast?id=\(cityId)"
        sendRequest(request, callback: callback)
    }
    
    func forecastWeatherByCoordinate(coord: CLLocationCoordinate2D, callback: (JSON?, NSError?) -> Void) {
        let request = "forecast?lat=\(coord.latitude)&lon=\(coord.longitude)"
        sendRequest(request, callback: callback)
    }
    
    func dailyForecastWeatherByCityName(cityName: String, forDays days: UInt, callback: (JSON?, NSError?) -> Void) {
        let request = "forecast/daily?q=\(cityName)&cnt=\(days)"
        sendRequest(request, callback: callback)
    }
    
    func dailyForecastWeatherByCityId(cityId: String, forDays days: UInt, callback: (JSON?, NSError?) -> Void) {
        let request = "forecast/daily?id=\(cityId)&cnt=\(days)"
        sendRequest(request, callback: callback)
    }
    
    func dailyForecastWeatherByCoordinate(coord: CLLocationCoordinate2D, forDays days: UInt, callback: (JSON?, NSError?) -> Void) {
        let request = "forecast/daily?lat=\(coord.latitude)&lon=\(coord.longitude)&cnt=\(days)"
        sendRequest(request, callback: callback)
    }
}
