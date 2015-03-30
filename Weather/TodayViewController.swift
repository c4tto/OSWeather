//
//  FirstViewController.swift
//  Weather
//
//  Created by Ondřej Štoček on 21.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {
    
    @IBOutlet var localityLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherDescLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var rainLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var windDirectionLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    
    var weatherDataModel: WeatherDataModel {
        get {
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            return appDelegate.weatherDataModel
        }
    }

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let location: String? = nil
        
        self.loadWeather(location) { (json, error) -> Void in
            if let json = json {
                self.displayWeather(json)
            } else {
                println(error)
            }
        }
    }
    
    func loadWeather(location: String?, callback: (JSON?, NSError?) -> Void) {
        if let location = location {
            self.weatherDataModel.weatherForLocation(location, callback)
        } else {
            self.weatherDataModel.weatherForCurrentLocation(callback)
        }
    }
    
    func displayWeather(json: JSON) {
        if let city = json["name"].string {
            if let country = json["sys"]["country"].string {
                self.localityLabel.text = "\(city), \(country)"
            }
        }
        if let weatherDesc = json["weather"][0]["main"].string {
            self.weatherDescLabel.text = weatherDesc
        }
        if let temp = json["main"]["temp"].float {
            self.temperatureLabel.text = "\(Int(round(temp)))\(self.weatherDataModel.temperatureUnit)"
        }
        if let humidity = json["main"]["humidity"].int {
            self.humidityLabel.text = "\(humidity) %"
        }
        if let rain = json["rain"]["1h"].float ?? json["rain"]["3h"].float ?? 0.0 {
            let rainString = String(format: "%.1f", rain)
            self.rainLabel.text = "\(rainString) mm"
        }
        if let pressure = json["main"]["pressure"].int {
            self.pressureLabel.text = "\(pressure) hPa"
        }
        if let windDeg = json["wind"]["deg"].float {
            self.windDirectionLabel.text = self.windDirectionDescription(windDeg)
        }
        if let windSpeed = json["wind"]["speed"].float {
            self.windSpeedLabel.text = "\(Int(round(windSpeed)))\(self.weatherDataModel.speedUnit)"
        }
    }
    
    func windDirectionDescription(windDeg: Float) -> String? {
        switch windDeg {
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
}
