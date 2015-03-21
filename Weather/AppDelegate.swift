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
        let barImage = UIImage(named: "Bar")?.resizableImageWithCapInsets(UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
        
        UINavigationBar.appearance().setBackgroundImage(barImage, forBarMetrics: .Default)
        UINavigationBar.appearance().shadowImage = UIImage(named: "BarLine")
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "ProximaNova-semibold", size: 18) ?? UIFont.systemFontOfSize(18)
        ]
        
        UITabBar.appearance().backgroundImage = barImage
        UITabBarItem.appearance().setTitleTextAttributes([
            NSFontAttributeName: UIFont(name: "ProximaNova-semibold", size: 10) ?? UIFont.systemFontOfSize(10)
        ], forState: .Normal)
    }
}

