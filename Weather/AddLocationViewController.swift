//
//  AddLocationViewController.swift
//  Weather
//
//  Created by Ondřej Štoček on 25.03.15.
//  Copyright (c) 2015 Ondrej Stocek. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate {
    
    @IBOutlet var closeBarButtonItem: UIBarButtonItem!
    
    var mapItems: [MKMapItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchDisplayController?.displaysSearchBarInNavigationBar = true
        self.searchDisplayController?.navigationItem.rightBarButtonItem = closeBarButtonItem
        self.searchDisplayController?.searchResultsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.searchDisplayController?.searchBar.becomeFirstResponder()
    }
    
    // MARK: - Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mapItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        let placemark = self.mapItems[indexPath.row].placemark
        cell.textLabel?.text = "\(placemark.locality), \(placemark.country)"
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let placemark = self.mapItems[indexPath.row].placemark
        self.weatherDataModel.addLocationWithName(placemark.locality, country: placemark.country, countryCode: placemark.countryCode)
        self.performSegueWithIdentifier("dismissAddLocation", sender: self)
    }
    
    // MARK: - Search Display Controller Delegate
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchString
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response, error) in
            if let response = response {
                let mapItems = response.mapItems as [MKMapItem]
                self.mapItems = mapItems.filter { (mapItem) in
                    return mapItem.placemark.locality != nil
                }
                controller.searchResultsTableView.reloadData()
            }
        }
        return false
    }
}
