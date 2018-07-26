//
//  City+CoreDataClass.swift
//  CitiesOfTheWorld
//
//  Created by Jorge Sirvent on 24/7/18.
//  Copyright © 2018 Jorge Sirvent. All rights reserved.
//
//

import Foundation
import CoreData

@objc(City)
public class City: NSManagedObject {
    public static func getCityMatchingId(_ cityId: Int16) -> City? {
        do {
            let fetchRequest: NSFetchRequest = City.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == \(cityId)")
            let city = try CoreDataUtils.shared.persistentContainer.viewContext.fetch(fetchRequest)
            return city.count > 0 ? city[0] : nil
        }
        catch {
            print("Error while fetching cities from Core Data")
            return nil
        }
    }
    
    public static func getCitiesFromPage(_ pageNumber: Int16) -> [City] {
        let fetchRequest:NSFetchRequest = City.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pageNumber == \(pageNumber)")
        do {
            let cities = try CoreDataUtils.shared.persistentContainer.viewContext.fetch(fetchRequest) 
            return cities
        }
        catch {
            print("Error while fetching cities from Core Data")
            return []
        }
    }
}

public class CityParser {
    static let KEY_DATA = "data"
    static let KEY_ITEMS = "items"
    static let KEY_ID = "id"
    static let KEY_NAME = "name"
    static let KEY_LATITUDE = "lat"
    static let KEY_LONGITUDE = "lng"
    static let KEY_COUNTRY_ID = "country_id"
    static let KEY_COUNTRY = "country"
    
    // Convenience method created for the base case.
    public static func parseCitiesFromHttpResponse(_ jsonResponse: Any) -> [City] {
        return parseCitiesFromHttpResponse(jsonResponse, withFilterString: "")
    }
    
    public static func parseCitiesFromHttpResponse(_ jsonResponse: Any, withFilterString filterString: String) -> [City] {
        guard let jsonResponse = jsonResponse as? [String:Any],
            let data = jsonResponse[KEY_DATA] as? [String:Any],
            let items = data[KEY_ITEMS] as? [[String:Any]] else {
                // It should never get inside here unless there was something going on with the server response.
                return []
        }
        
        // First we retrieve pagination info. It will be useful later on.
        var currentPage = -1
        if let paginationInfo = data["pagination"] as? [String:Any] {
            currentPage = paginationInfo["current_page"] as! Int
            let lastPage = paginationInfo["last_page"] as! Int16
            
            let pagingInfo = PagingInfo.getPagingInfo()
            pagingInfo?.lastPage = lastPage
            pagingInfo?.lastCachedPage = Int16(currentPage)
        }
        
        // Then the cities itself
        var cities = [City]()
        for item in items {
            guard let cityId = item[KEY_ID] as? Int16 else {
                continue
            }
            // First we try to get the city from the cache. If it's not there, we create a new value.
            var city = City.getCityMatchingId(cityId)
            
            if city == nil || city?.pageNumber == 0 {
                // Parse city info
                // If the city is nil we create it from the scratch. If not, it means we already cached it from a filtered search, in that case we just update the page number to the correct one.
                if city == nil {
                    city = City(context: CoreDataUtils.shared.persistentContainer.viewContext)
                }
                city!.name = item[KEY_NAME] as? String
                city!.id = cityId
                
                //If we're filtering we don't want to store the pageNumber. We just set a placeholder.
                city!.pageNumber = filterString.isEmpty ? Int16(currentPage) : 0
                if let latitude = item[KEY_LATITUDE] as? Double,
                    let longitude = item[KEY_LONGITUDE] as? Double {
                    city!.latitude = latitude
                    city!.longitude = longitude
                }
            }
            
            // Parse Country info
            if let countryInfo = item[CityParser.KEY_COUNTRY] as? [String:Any],
                let countryId = countryInfo[KEY_ID] as? Int16 {
                // First we try to get the country from the cache. If it's not there, we create a new value.
                var country = Country.getCountryMatchingId(Int(countryId))
                
                if country == nil {
                    country = Country(context: CoreDataUtils.shared.persistentContainer.viewContext)
                    country!.name = countryInfo[KEY_NAME] as? String
                    country!.id = countryId
                }
                city!.country = country!
            }
            cities.append(city!)
        }
        
        // In the last step, we commit changes to the db so they're persisted.
        CoreDataUtils.shared.saveContext()
        
        return cities
    }
}
