//
//  ViewController.swift
//  CitiesOfTheWorld
//
//  Created by Jorge Sirvent on 24/7/18.
//  Copyright © 2018 Jorge Sirvent. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var cities = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
    }
    
    // MARK: UITableViewDelegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cities.count == 0 {
            return 1
        }
        else {
            return cities.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if cities.count == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "NoResultsFound")!
        }
        else {
            let city = cities[indexPath.row]
            cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
            cell.textLabel?.text = city.name
            cell.detailTextLabel?.text = city.country?.name
        }
        
        return cell
    }
}

extension MainTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
