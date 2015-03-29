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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let locationId: String? = nil
        
        self.loadWeather(locationId) {
            (result: [NSObject: AnyObject]?, error: NSError?) -> Void in
            if let result = result {
                self.displayWeather(result)
            }
        }
    }
    
    func loadWeather(locationId: String?, callback: ([NSObject: AnyObject]?, NSError?) -> Void) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let name = locationId {
            appDelegate.weatherDataModel.weatherForLocationWithName(name, callback)
        } else {
            appDelegate.weatherDataModel.weatherForCurrentLocation(callback)
        }
    }
    
    func displayWeather(result: [NSObject: AnyObject]) {
        println(result)
        
        let json = JSON(result)
        
        if let city = json["name"].string {
            if let country = json["sys"]["country"].string {
                self.localityLabel.text = "\(city), \(country)"
            }
        }
        if let weatherDesc = json["weather"][0]["main"].string {
            self.weatherDescLabel.text = weatherDesc
        }
        if let temp = json["main"]["temp"].float {
            self.temperatureLabel.text = "\(Int(round(temp))) \(self.temperatureUnit())"
        }
        if let humidity = json["main"]["humidity"].int {
            self.humidityLabel.text = "\(humidity) %"
        }
        if let rain = json["rain"]["1h"].float {
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
            self.windSpeedLabel.text = "\(Int(round(windSpeed))) km/h"
        }
    }
    
    func temperatureUnit() -> String {
        return "°C" // "°F", "K"
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


/*
[Kružberská 1908/1<GEOMapItemStorage: 0x17da2830> {
    placeData = {
        component = ({
            "cache_control" = CACHEABLE;
            "start_index" = 0;
            status = "STATUS_SUCCESS";
            ttl = 15768000;
            type = "COMPONENT_TYPE_HOURS";
            "values_available" = 0;
            version = 7;
            "version_domain" = (apple, revgeo, CZ);
        }, {
            "cache_control" = CACHEABLE;
            "start_index" = 0;
            status = "STATUS_SUCCESS";
            ttl = 15768000;
            type = "COMPONENT_TYPE_RATING";
            "values_available" = 0;
            version = 7;
            "version_domain" = (apple, revgeo, CZ);
        }, {
            "cache_control" = CACHEABLE;
            "start_index" = 0;
            status = "STATUS_SUCCESS";
            ttl = 15768000;
            type = "COMPONENT_TYPE_FLYOVER";
            "values_available" = 0;
            version = 7;
            "version_domain" = (apple, revgeo, CZ);
        }, {
            "cache_control" = CACHEABLE;
            "start_index" = 0;
            status = "STATUS_SUCCESS";
            ttl = 15768000;
            type = "COMPONENT_TYPE_BOUNDS";
            "values_available" = 0;
            version = 7;
            "version_domain" = (apple, revgeo, CZ);
        }, {
            "cache_control" = CACHEABLE;
            "start_index" = 0;
            status = "STATUS_SUCCESS";
            ttl = 15768000;
            type = "COMPONENT_TYPE_ROAD_ACCESS_INFO";
            value = ({
                "access_info" = {
                    "road_access_point" = ({
                        drivingDirection = "ENTRY_EXIT";
                        location = {
                            lat = "50.0719289";
                            lng = "14.5051505";
                        };
                        walkingDirection = "ENTRY_EXIT";
                    });
                };
            });
            "values_available" = 1;
            version = 7;
            "version_domain" = (apple, revgeo, CZ);
        }, {
            "cache_control" = CACHEABLE;
            "start_index" = 0;
            status = "STATUS_SUCCESS";
            ttl = 15768000;
            type = "COMPONENT_TYPE_PLACE_INFO";
            value = ({
                "place_info" = {
                    center = {
                        lat = "50.0721208";
                        lng = "14.5049254";
                    };
                    timezone = {
                        identifier = "Europe/Prague";
                    };
                };
            });
            "values_available" = 1;
            version = 7;
            "version_domain" = (apple, revgeo, CZ);
        }, {
            "cache_control" = CACHEABLE;
            "start_index" = 0;
            status = "STATUS_SUCCESS";
            ttl = 15768000;
            type = "COMPONENT_TYPE_ENTITY";
            value = ({
                entity = {
                    name = ({
                        locale = "cs_CZ";
                        "string_value" = "Kru\U017ebersk\U00e1 1908/1";
                    }, {
                        locale = cs;
                        "string_value" = "Kru\U017ebersk\U00e1 1908/1";
                    });
                    type = ADDRESS;
                };
            });
            "values_available" = 1;
            version = 7;
            "version_domain" = (apple, revgeo, CZ);
        }, {
            "cache_control" = CACHEABLE;
            "start_index" = 0;
            status = "STATUS_SUCCESS";
            ttl = 15768000;
            type = "COMPONENT_TYPE_ADDRESS";
            value = ({
                address = {
                    "known_accuracy" = POINT;
                    "localized_address" = ({
                        address = {
                            formattedAddressLine = (
                                "Kru\U017ebersk\U00e1 1908/1",
                                "100 00 Praha",
                                "\U010cesk\U00e1 republika"
                            );
                            structuredAddress = {
                                administrativeArea = "Hlavn\U00ed m\U011bsto Praha";
                                country = "\U010cesk\U00e1 republika";
                                countryCode = CZ;
                                dependentLocality = (
                                    Praha,
                                    "Praha 10",
                                    Strasnice
                                );
                                fullThoroughfare = "Kru\U017ebersk\U00e1 1908/1";
                                geoId = ();
                                locality = Praha;
                                postCode = "100 00";
                                subAdministrativeArea = "Hlavn\U00ed m\U011bsto Praha";
                                subLocality = Strasnice;
                                subThoroughfare = "1908/1";
                                thoroughfare = "Kru\U017ebersk\U00e1";
                            };
                        };
                        locale = "cs_CZ";
                    }, {
                        address = {
                            formattedAddressLine = (
                                "Kru\U017ebersk\U00e1 1908/1",
                                "100 00 Praha",
                                "\U010cesk\U00e1 republika"
                            );
                            structuredAddress = {
                                administrativeArea = "Hlavn\U00ed m\U011bsto Praha";
                                country = "\U010cesk\U00e1 republika";
                                countryCode = CZ;
                                dependentLocality = (
                                    Praha,
                                    "Praha 10",
                                    Strasnice
                                );
                                fullThoroughfare = "Kru\U017ebersk\U00e1 1908/1";
                                geoId = ();
                                locality = Praha;
                                postCode = "100 00";
                                subAdministrativeArea = "Hlavn\U00ed m\U011bsto Praha";
                                subLocality = Strasnice;
                                subThoroughfare = "1908/1";
                                thoroughfare = "Kru\U017ebersk\U00e1";
                            };
                        };
                        locale = cs;
                    });
                };
            });
            "values_available" = 1;
            version = 7;
            "version_domain" = (apple, revgeo, CZ);
        }, {
            "cache_control" = CACHEABLE;
            "start_index" = 0;
            status = "STATUS_SUCCESS";
            ttl = 15768000;
            type = "COMPONENT_TYPE_AMENITIES";
            "values_available" = 0;
            version = 7;
            "version_domain" = (apple, revgeo, CZ);
        }, {
            "cache_control" = CACHEABLE;
            "start_index" = 0;
            status = "STATUS_SUCCESS";
            ttl = 15768000;
            type = "COMPONENT_TYPE_STYLE_ATTRIBUTES";
            "values_available" = 0;
            version = 7;
            "version_domain" = (apple, revgeo, CZ);
        });
        "result_provider_id" = 7618;
        status = "STATUS_SUCCESS";
    };
}]
*/