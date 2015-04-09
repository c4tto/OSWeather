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
        if let error = self.error {
            self.weatherInfoView.hidden = true
            self.activityIndicator.hidden = true
            self.errorLabel.hidden = false
            self.errorLabel.text = self.weatherDataModel.descriptionForError(error)
            self.errorLabel.sizeToFit()
        } else {
            self.weatherInfoView.hidden = false
            self.errorLabel.hidden = true
            self.activityIndicator.hidden = self.weatherDataItem != nil
            
            if let location = self.weatherDataModel.selectedLocation {
                let locationString = "\(location.name), \(location.country)"
                self.localityLabel.attributedText = NSAttributedString(string: locationString)
            } else if let placemark = self.weatherDataModel.locationManager.placemark {
                var location = "\(placemark.locality), \(placemark.country)"
                self.localityLabel.attributedText = self.attributedStringWithArrow(location)
            } else {
                self.localityLabel.attributedText = NSAttributedString(string: "----")
            }
            
            self.weatherImageView.image = self.weatherDataItem?.image
            self.conditionLabel.text = self.weatherDataItem?.conditionString ?? "----"
            self.temperatureLabel.text = self.weatherDataItem?.temperatureString ?? "----"
            self.humidityLabel.text = self.weatherDataItem?.humidityString ?? "----"
            self.rainLabel.text = self.weatherDataItem?.rainString ?? "----"
            self.pressureLabel.text = self.weatherDataItem?.pressureString ?? "----"
            self.windDirectionLabel.text = self.weatherDataItem?.windDirectionString ?? "----"
            self.windSpeedLabel.text = self.weatherDataItem?.windSpeedString ?? "----"
            
            self.shareButton.enabled = self.weatherDataItem != nil
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
