//
//  AppDelegate.swift
//  Weather
//
//  Created by Ondřej Štoček on 21.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        initAppearance()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
    }
    
    func applicationWillTerminate(application: UIApplication) {
    }
    
    func initAppearance() {
        let textColor = UIColor(rgba: "#333333")
        let highlightedTextColor = UIColor(rgba: "#2f91ff")
        let barImage = UIImage(named: "Bar")?.resizableImageWithCapInsets(UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
        
        UINavigationBar.appearance().setBackgroundImage(barImage, forBarMetrics: .Default)
        UINavigationBar.appearance().shadowImage = UIImage(named: "BarLine")
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "ProximaNova-semibold", size: 18) ?? UIFont.systemFontOfSize(18),
            NSForegroundColorAttributeName: textColor,
        ]
        
        UITabBar.appearance().backgroundImage = barImage
        UITabBar.appearance().tintColor = textColor
        UITabBar.appearance().selectedImageTintColor = highlightedTextColor
        UITabBarItem.appearance().setTitleTextAttributes([
            NSFontAttributeName: UIFont(name: "ProximaNova-semibold", size: 10) ?? UIFont.systemFontOfSize(10),
        ], forState: .Normal)
    }
    
    // Why there is no correctly working pattern for lazy initiated readonly property in Swift??? Aaaaaaaargh!!!!
    private var _weatherApi: OWMWeatherAPI?
    var weatherApi: OWMWeatherAPI {
        get {
            if _weatherApi == nil {
                let weatherApiKey = "3b9e5a5284eaa6be66f5cceb016b5471"
                _weatherApi = OWMWeatherAPI(APIKey: weatherApiKey)
            }
            return _weatherApi!
        }
    }
}

