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
    @IBOutlet var conditionLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var rainLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var windDirectionLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.weatherDataModel.weatherForCurrentLocation {(placemark, weatherDataItem, error) in
            self.displayWeather(placemark, weatherDataItem)
            if let error = error {
                println(error)
            }
        }
    }
    
    func displayWeather(placemark: CLPlacemark?, _ weatherDataItem: WeatherDataItem?) {
        if let placemark = placemark {
            self.localityLabel.text = "\(placemark.locality), \(placemark.country)"
        }
        if let conditionString = weatherDataItem?.conditionString {
            self.conditionLabel.text = conditionString
        }
        if let temperatureString = weatherDataItem?.temperatureString {
            self.temperatureLabel.text = temperatureString
        }
        if let humidityString = weatherDataItem?.humidityString {
            self.humidityLabel.text = humidityString
        }
        if let rainString = weatherDataItem?.rainString {
            self.rainLabel.text = rainString
        }
        if let pressureString = weatherDataItem?.pressureString {
            self.pressureLabel.text = pressureString
        }
        if let windDirectionString = weatherDataItem?.windDirectionString {
            self.windDirectionLabel.text = windDirectionString
        }
        if let windSpeedString = weatherDataItem?.windSpeedString {
            self.windSpeedLabel.text = windSpeedString
        }
    }
}
