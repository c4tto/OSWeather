//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Ondřej Štoček on 21.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var conditionLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherImageView: UIImageView!
    
    override func prepareForReuse() {
        self.titleLabel.text = "------"
        self.conditionLabel.text = "------"
        self.temperatureLabel.text = "----"
        self.weatherImageView.image = nil
    }
}
