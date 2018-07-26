//
//  ViewController.swift
//  CitiesOfTheWorld
//
//  Created by Jorge Sirvent on 24/7/18.
//  Copyright © 2018 Jorge Sirvent. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    // Search bar controller
    private let searchController = UISearchController(searchResultsController: nil)
    // This flag is used to avoid loading the same page several times
    private var isLoading = false {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = isLoading
        }
    }
    // Array of cached cities
    private var cities = [City]()
    private var filteredCities = [City]()
    
    // Model provider
    private let provider = CityProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        
        // Start the cities fetch
        loadMoreCities()
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cities.count == 0 {
            return 1
        }
        else {
            if searchController.searchBar.text == "" {
                return cities.count
            }
            else {
                return filteredCities.count
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if cities.count == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "NoResultsFound")!
        }
        else {
            var city: City
            if searchController.searchBar.text == "" {
                city = cities[indexPath.row]
            }
            else {
                city = filteredCities[indexPath.row]
            }
            cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
            cell.textLabel?.text = city.name
            cell.detailTextLabel?.text = city.country?.name
            
            // When we show the last cell, we ask for a new page of info depending if we're filtering results or not
            if indexPath.row == cities.count-1 && !isLoading && searchController.searchBar.text!.isEmpty {
                loadMoreCities()
            }
            else if indexPath.row == filteredCities.count-1 && !isLoading && !searchController.searchBar.text!.isEmpty {
                loadMoreFilteredCities()
            }
        }
        
        return cell
    }
    
    // MARK: Aux methods
    private func loadMoreCities() {
        isLoading = true
        provider.getNewCitiesPagewithCompletionHandler { (cities) -> (Void) in
            DispatchQueue.main.async {
                self.isLoading = false
                guard !cities.isEmpty else {
                    return
                }
                
                self.cities.append(contentsOf: cities)
                self.filteredCities = [City]()
                self.tableView.reloadData()
            }
        }
    }
    
    private func loadMoreFilteredCities() {
        isLoading = true
        provider.getCitiesMatching(searchController.searchBar.text!, withCompletionHandler: { (cities) -> (Void) in
            DispatchQueue.main.async {
                self.isLoading = false
                guard !cities.isEmpty else {
                    return
                }
                
                self.filteredCities.append(contentsOf: cities)
                self.tableView.reloadData()
            }
        })
    }
}

// MARK: Search Results Updater

extension MainTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let filterText = searchController.searchBar.text
        
        // If the user has removed all the text in the searchBar we reload the normal array
        guard filterText != "" else {
            filteredCities = [City]()
            tableView.reloadData()
            return
        }
        
        isLoading = true
        provider.getCitiesMatching(searchController.searchBar.text!, withCompletionHandler: { (cities) -> (Void) in
            DispatchQueue.main.async {
                self.isLoading = false
                self.filteredCities = cities
                self.tableView.reloadData()
            }
        })
    }
}
