//
//  UIViewController+Error.swift
//  Weather
//
//  Created by Ondřej Štoček on 01.04.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayError(error: NSError?) {
        if let error = error {
            UIAlertView(title: error.localizedDescription,
                message: error.localizedRecoverySuggestion,
                delegate: nil,
                cancelButtonTitle: "OK").show()
        }
    }
}


