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
    
    public func getNewCitiesPagewithCompletionHandler(_ completionHandler: @escaping (([City]) -> (Void))) {
        DispatchQueue.global().async {
            guard let paginInfo = PagingInfo.getPagingInfo() else {
                return
            }
            
            // If the page we're fetching is cached already we retrieve it from db. Otherwise we ask the server for that info.
            if paginInfo.lastCachedPage >= self.currentPage {
                let cachedCities = City.getCitiesFromPage(self.currentPage)
        
                completionHandler(cachedCities)
            }
            else {
                HTTPClient.fetchCitiesPageNumber(self.currentPage, withCompletionHandler: completionHandler)
            }
        }
    }
    
    public func getCitiesMatching(_ string: String, withCompletionHandler completionHandler: (([City]) -> (Void))) {
    }
}
