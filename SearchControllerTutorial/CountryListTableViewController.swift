//
//  CountryListTableViewController.swift
//  SearchControllerTutorial
//
//  Created by Kc on 15/02/2016.
//  Copyright © 2016 Kenechi Okolo. All rights reserved.
//

import UIKit

class CountryListTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    let countries = JSON(data: NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("countries", ofType: "json")!)!)
    var filteredCountries = [JSON]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.setContentOffset(CGPoint(x: 0, y: searchController.searchBar.frame.size.height), animated: false)
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredCountries.count
        }
        return countries.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("countryCell", forIndexPath: indexPath)

        var data: JSON
        
        if searchController.active && searchController.searchBar.text != "" {
            data = filteredCountries[indexPath.row]
        } else {
            data = countries[indexPath.row]
        }
        
        let countryName = data["name"]["common"].stringValue
        let countryCapital = data["capital"].stringValue
        
        cell.textLabel?.text = countryName
        cell.detailTextLabel?.text = countryCapital

        return cell
    }
    
    func filterContentForSearchText(searchText: String) {
        filteredCountries = countries.array!.filter { country in
            return country["name"]["common"].stringValue.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }

}

extension CountryListTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
