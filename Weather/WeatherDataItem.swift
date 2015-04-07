//
//  WeatherDataItem.swift
//  Weather
//
//  Created by Ondřej Štoček on 01.04.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import Foundation

enum TemperatureUnit: String {
    case Celsius = "Celsius"
    case Fahrenheit = "Fahrenheit"
}

enum LengthUnit: String {
    case Metric = "Metric"
    case Imperial = "Imperial"
}

struct WeatherDataItem {
    
    static var temperatureUnit: TemperatureUnit = .Celsius
    static var lengthUnit: LengthUnit = .Metric
    
    var locationId: UInt?
    var locationName: String?
    var locationCountry: String?
    var locationIsoCountryCode: String?
    
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
    
    var imageId: String?
    var imageName: String? {
        if let imageId = imageId {
            switch imageId {
            case "01d", "01n":
                return "Sun"
            case "02d", "02n", "03d", "03n", "04d", "04n":
                return "Cloudy"
            case "09d", "09n", "10d", "10n":
                return "Rain"
            case "11d", "11n":
                return "Lightning"
            case "13d", "13n": // should be snow
                return "Rain"
            case "50d", "50n": // should be mist
                return "Rain"
            default:
                return nil
            }
        }
        return nil
    }
    var image: UIImage? {
        if let imageName = imageName {
            return UIImage(named: imageName)
        }
        return nil
    }
    
    var temperature: Float?
    var temperatureValue: Float? {
        if let temperature = temperature {
            let celsiusValue = temperature - 272.15
            return WeatherDataItem.temperatureUnit == .Celsius ? celsiusValue : celsiusValue * 1.8 + 32
        }
        return nil
    }
    var temperatureUnit: String {
        return WeatherDataItem.temperatureUnit == .Celsius ? "°C" : "°F"
    }
    var temperatureString: String? {
        if let temperatureValue = temperatureValue {
            return "\(Int(round(temperatureValue)))\(temperatureUnit)"
        }
        return nil
    }
    var temperatureShortString: String? {
        if let temperatureValue = temperatureValue {
            return "\(Int(round(temperatureValue)))°"
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
    var windSpeedValue: Float? {
        if let windSpeed = windSpeed {
            return WeatherDataItem.lengthUnit == .Metric ? windSpeed : windSpeed * 3.2808
        }
        return nil
    }
    var windSpeedUnit: String {
        return WeatherDataItem.lengthUnit == .Metric ? "m/s" : "ft/s"
    }
    var windSpeedString: String? {
        if let windSpeedValue = windSpeedValue {
            return "\(Int(round(windSpeedValue))) \(windSpeedUnit)"
        }
        return nil
    }
    
    init(_ json: JSON) {
        locationId = json["id"].uInt
        if let dt = json["dt"].float {
            timestamp = NSTimeInterval(dt)
        }
        condition = json["weather", 0, "main"].string
        imageId = json["weather", 0, "icon"].string
        temperature = json["main", "temp"].float ?? json["temp", "day"].float
        humidity = json["main", "humidity"].uInt
        rain = json["rain", "1h"].float ?? json["rain", "3h"].float ?? json["rain"].float
        pressure = json["main", "pressure"].uInt
        windDirection = json["wind", "deg"].float
        windSpeed = json["wind", "speed"].float
    }
    
    init(_ json: JSON, locationItem: LocationDataItem) {
        self.init(json)
        self.locationName = locationItem.name
        self.locationCountry = locationItem.country
        self.locationIsoCountryCode = locationItem.isoCountryCode
    }
    
    init(_ json: JSON, placemark: CLPlacemark) {
        self.init(json)
        self.locationName = placemark.locality
        self.locationCountry = placemark.country
        self.locationIsoCountryCode = placemark.ISOcountryCode
    }
    
}

/*
http://api.openweathermap.org/data/2.5/weather?q=London,uk
{
    "coord":{
        "lon":-0.13,
        "lat":51.51
    },
    "sys":{
        "message":0.2919,
        "country":"GB",
        "sunrise":1428039025,
        "sunset":1428086221
    },
    "weather":[{
        "id":500,
        "main":"Rain",
        "description":"light rain",
        "icon":"10d"
    }],
    "base":"stations",
    "main":{
        "temp":278.915,
        "temp_min":278.915,
        "temp_max":278.915,
        "pressure":1021.49,
        "sea_level":1029.59,
        "grnd_level":1021.49,
        "humidity":96
    },
    "wind":{
        "speed":2.59,
        "deg":161.505
    },
    "clouds":{
        "all":92
    },
    "rain":{
        "3h":0.38
    },
    "dt":1428045362,
    "id":2643743,
    "name":"London",
    "cod":200
}

http://api.openweathermap.org/data/2.5/forecast/daily?q=London,uk&cnt=2

{
    "cod":"200",
    "message":0.0184,
    "city":{
        "id":2643743,
        "name":"London",
        "coord":{
            "lon":-0.12574,
            "lat":51.50853
        },
        "country":"GB",
        "population":0,
        "sys":{
            "population":0
        }
    },
    "cnt":2,
    "list":[{
        "dt":1428062400,
        "temp":{
            "day":282.56,
            "min":278.02,
            "max":283.2,
            "night":278.8,
            "eve":281.94,
            "morn":278.02
        },
        "pressure":1019.47,
        "humidity":100,
        "weather":[{
            "id":501,
            "main":"Rain",
            "description":"moderate rain",
            "icon":"10d"
        }],
        "speed":4.16,
        "deg":132,
        "clouds":92,
        "rain":3.98
    },{
        "dt":1428148800,
        "temp":{
            "day":281.28,
            "min":274.21,
            "max":282.18,
            "night":274.21,
            "eve":280.37,
            "morn":275.99
        },
        "pressure":1032.62,
        "humidity":100,
        "weather":[{
            "id":801,
            "main":"Clouds",
            "description":"few clouds",
            "icon":"02d"
        }],
        "speed":4.58,
        "deg":38,
        "clouds":20
    }]
}
*/