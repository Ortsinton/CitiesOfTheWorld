//
//  CityProvider.swift
//  CitiesOfTheWorld
//
//  Created by Jorge Sirvent on 25/7/18.
//  Copyright © 2018 Jorge Sirvent. All rights reserved.
//

import UIKit

class CityProvider: NSObject {
    private var currentPage = Int16(1)
    private var currentFilteredPage = Int16(1)
    private var previousFilter = ""
    
    public func getNewCitiesPagewithCompletionHandler(_ completionHandler: @escaping (([City]) -> (Void))) {
        DispatchQueue.global().async {
            guard let pagingInfo = PagingInfo.getPagingInfo() else {
                return
            }
            
            self.previousFilter = ""
            
            // If the page we're fetching is cached already we retrieve it from db. Otherwise we ask the server for that info.
            if pagingInfo.lastCachedPage >= self.currentPage {
                let cachedCities = City.getCitiesFromPage(self.currentPage)
                
                completionHandler(cachedCities)
            }
            else {
                HTTPClient.fetchCitiesPageNumber(self.currentPage, withCompletionHandler: completionHandler)
            }
            
            // Once we have the results we increment the page to load.
            self.currentPage += 1
        }
    }
    
    public func getCitiesMatching(_ string: String, withCompletionHandler completionHandler: @escaping (([City]) -> (Void))) {
        DispatchQueue.global().async {
            if self.previousFilter != string {
                self.currentFilteredPage = 0
                self.previousFilter = string
            }
            
            HTTPClient.filterCitiesByString(string, forPageNumber: self.currentFilteredPage, withCompletionHandler: completionHandler)
            
            self.currentFilteredPage += 1
        }
    }
}
