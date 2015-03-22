//
//  AppTabBarController.swift
//  Weather
//
//  Created by Ondřej Štoček on 22.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

class AppTabBarController: UITabBarController, UITabBarControllerDelegate {

    @IBOutlet var locationBarButtonItem: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    // MARK: - Tab bar view controller delegate
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        self.navigationItem.rightBarButtonItem = viewController is SettingsTableViewController ? nil : locationBarButtonItem
    }
}
