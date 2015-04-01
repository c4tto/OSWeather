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
    @IBOutlet var shareButton: UIButton!
    
    var cachedCurrentLocation: (placemark: CLPlacemark?, weatherDataItem: WeatherDataItem?)?

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshWeather()
        
        self.weatherDataModel.weatherForCurrentLocation {(placemark, weatherDataItem, error) in
            self.cachedCurrentLocation = (placemark: placemark, weatherDataItem: weatherDataItem)
            self.refreshWeather()
            self.displayError(error)
        }
    }
    
    func refreshWeather() {
        let placemark = self.cachedCurrentLocation?.placemark
        let weatherDataItem = self.cachedCurrentLocation?.weatherDataItem
        if let placemark = placemark {
            self.localityLabel.attributedText = self.locationAttributedStringWithArrow(placemark)
            self.shareButton.enabled = true
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
    
    func locationAttributedStringWithArrow(placemark: CLPlacemark) -> NSAttributedString {
        let attachement = NSTextAttachment()
        attachement.image = UIImage(named: "Arrow")
        let attachementString = NSAttributedString(attachment: attachement)
        let placemarkString = NSMutableAttributedString(string: " \(placemark.locality), \(placemark.country)")
        placemarkString.insertAttributedString(attachementString, atIndex: 0)
        return placemarkString
    }
    
    @IBAction func shareWeather(sender: UIButton) {
        var sharedItems: [AnyObject] = []
        
        if let placemark = self.cachedCurrentLocation?.placemark {
            if let weatherDataItem = self.cachedCurrentLocation?.weatherDataItem {
                if let conditionString = weatherDataItem.conditionString {
                    if let temperatureString = weatherDataItem.temperatureString {
                        sharedItems.append("\(placemark.locality), \(placemark.country)")
                        sharedItems.append("\(temperatureString), \(conditionString)")
                    }
                }
            }
        }
        
        if sharedItems.count > 0 {
            let activityViewController = UIActivityViewController(activityItems: sharedItems, applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
    }
}
