//
//  FirstViewController.swift
//  Weather
//
//  Created by Ondřej Štoček on 21.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {
    
    @IBOutlet var weatherInfoView: UIView!
    @IBOutlet var weatherImageView: UIImageView!
    @IBOutlet var localityLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var conditionLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var rainLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var windDirectionLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var shareButton: UIButton!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var errorLabel: UILabel!
    
    var weatherDataItem: WeatherDataItem?
    var error: NSError?

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.weatherDataItem = nil
        self.error = nil
        self.updateView()
        
        self.weatherDataModel.weatherForSelectedLocation {(weatherDataItem, error) in
            self.weatherDataItem = weatherDataItem
            self.error = error
            self.updateView()
        }
    }
    
    func updateView() {
        if let weatherDataItem = self.weatherDataItem {
            self.activityIndicator.hidden = true
            self.errorLabel.hidden = true
            self.weatherInfoView.hidden = false
            if let name = weatherDataItem.locationName {
                if let country = weatherDataItem.locationCountry {
                    var location = "\(name), \(country)"
                    if self.weatherDataModel.selectedLocationIndex == nil {
                        self.localityLabel.attributedText = self.attributedStringWithArrow(location)
                    } else {
                        self.localityLabel.attributedText = NSAttributedString(string: location)
                    }
                    self.shareButton.enabled = true
                }
            }

            if let image = weatherDataItem.image {
                self.weatherImageView.image = image
            }
            if let conditionString = weatherDataItem.conditionString {
                self.conditionLabel.text = conditionString
            }
            if let temperatureString = weatherDataItem.temperatureString {
                self.temperatureLabel.text = temperatureString
            }
            if let humidityString = weatherDataItem.humidityString {
                self.humidityLabel.text = humidityString
            }
            if let rainString = weatherDataItem.rainString {
                self.rainLabel.text = rainString
            }
            if let pressureString = weatherDataItem.pressureString {
                self.pressureLabel.text = pressureString
            }
            if let windDirectionString = weatherDataItem.windDirectionString {
                self.windDirectionLabel.text = windDirectionString
            }
            if let windSpeedString = weatherDataItem.windSpeedString {
                self.windSpeedLabel.text = windSpeedString
            }
        } else if let error = self.error {
            self.weatherInfoView.hidden = true
            self.activityIndicator.hidden = true
            self.errorLabel.hidden = false
            self.errorLabel.text = self.weatherDataModel.descriptionForError(error)
            self.errorLabel.sizeToFit()
        } else {
            self.weatherInfoView.hidden = true
            self.errorLabel.hidden = true
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()
            // show loading spinner
        }
    }
    
    func attributedStringWithArrow(string: String) -> NSAttributedString {
        let attachement = NSTextAttachment()
        attachement.image = UIImage(named: "Arrow")
        let attachementString = NSAttributedString(attachment: attachement)
        let placemarkString = NSMutableAttributedString(string: " " + string)
        placemarkString.insertAttributedString(attachementString, atIndex: 0)
        return placemarkString
    }
    
    @IBAction func shareWeather(sender: UIButton) {
        if let weatherDataItem = self.weatherDataItem {
            var sharedItems: [AnyObject] = [
                "\(weatherDataItem.locationName), \(weatherDataItem.locationCountry)",
                "\(weatherDataItem.temperatureString), \(weatherDataItem.conditionString)",
            ]
        
            let activityViewController = UIActivityViewController(activityItems: sharedItems, applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
    }
}
