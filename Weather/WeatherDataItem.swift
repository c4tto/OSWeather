//
//  WeatherDataItem.swift
//  Weather
//
//  Created by Ondřej Štoček on 01.04.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

struct WeatherDataItem {
    
    var locationId: UInt?
    
    var timestamp: NSTimeInterval?
    var weakDayString: String? {
        if let timestamp = timestamp {
            let date = NSDate(timeIntervalSince1970:timestamp)
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.stringFromDate(date)
        }
        return nil
    }
    
    var condition: String?
    var conditionString: String? {
        return condition
    }
    
    var temperature: Float?
    var temperatureString: String? {
        if let temperature = temperature {
            let temperatureUnit = self.weatherDataModel?.temperatureUnit ?? "°C"
            return "\(Int(round(temperature)))\(temperatureUnit)"
        }
        return nil
    }
    var temperatureShortString: String? {
        if let temperature = temperature {
            return "\(Int(round(temperature)))°"
        }
        return nil
    }
    
    var humidity: UInt?
    var humidityString: String? {
        if let humidity = humidity {
            return "\(humidity) %"
        }
        return nil
    }
    
    var rain: Float?
    var rainString: String? {
        if let rain = rain {
            let rainString = String(format: "%.1f", rain)
            return "\(rainString) mm"
        }
        return nil
    }
    
    var pressure: UInt?
    var pressureString: String? {
        if let pressure = pressure {
            return "\(pressure) hPa"
        }
        return nil
    }
    
    var windDirection: Float?
    var windDirectionString: String? {
        if let windDirection = windDirection {
            switch windDirection {
            case 348.75..<360, 0..<11.25:
                return "N"
            case 11.25..<33.75:
                return "NNE"
            case 33.75..<56.25:
                return "NE"
            case 56.25..<78.75:
                return "ENE"
            case 78.75..<101.25:
                return "E"
            case 101.25..<123.75:
                return "ESE"
            case 123.75..<146.25:
                return "SE"
            case 146.25..<168.75:
                return "SSE"
            case 168.75..<191.25:
                return "S"
            case 191.25..<213.75:
                return "SSW"
            case 213.75..<236.25:
                return "SW"
            case 236.25..<258.75:
                return "WSW"
            case 258.75..<281.25:
                return "W"
            case 281.25..<303.75:
                return "WNW"
            case 303.75..<326.25:
                return "NW"
            case 326.25..<348.75:
                return "NNW"
            default:
                return nil
            }
        }
        return nil
    }
    
    var windSpeed: Float?
    var windSpeedString: String? {
        if let windSpeed = windSpeed {
            let speedUnit = self.weatherDataModel?.speedUnit ?? "m/s"
            return "\(Int(round(windSpeed))) \(speedUnit)"
        }
        return nil
    }
    
    weak var weatherDataModel: WeatherDataModel?
    
    init(json: JSON, model: WeatherDataModel) {
        weatherDataModel = model
        locationId = json["id"].uInt
        if let dt = json["dt"].float {
            timestamp = NSTimeInterval(dt)
        }
        condition = json["weather", 0, "main"].string
        temperature = json["main", "temp"].float ?? json["temp", "day"].float
        humidity = json["main", "humidity"].uInt
        rain = json["rain", "1h"].float ?? json["rain", "3h"].float ?? json["rain"].float
        pressure = json["main", "pressure"].uInt
        windDirection = json["wind", "deg"].float
        windSpeed = json["wind", "speed"].float
    }
}
