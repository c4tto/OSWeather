//
//  FirstViewController.swift
//  Weather
//
//  Created by Ondřej Štoček on 21.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let locationId: String? = nil //"Prague,cz"
        self.loadWeather(locationId) {
            (result: [NSObject: AnyObject]?, error: NSError?) -> Void in
            if let result = result {
                println(result)
                let jsonResult = JSON(result)
                /*
                if let countryCode = jsonResult["sys"]["country"].string {
                    let countryId = NSLocale.localeIdentifierFromComponents([NSLocaleCountryCode: countryCode])
                    let countryName = NSLocale.currentLocale().displayNameForKey(NSLocaleIdentifier, value: countryId)
                    println(countryName)
                }
                */
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