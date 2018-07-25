//
//  Country+CoreDataClass.swift
//  CitiesOfTheWorld
//
//  Created by Jorge Sirvent on 24/7/18.
//  Copyright © 2018 Jorge Sirvent. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Country)
public class Country: NSManagedObject {
    public static func getCountryMatchingId(_ countryId: Int) -> Country? {
        do {
            let fetchRequest: NSFetchRequest = Country.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == \(countryId)")
            let country = try CoreDataUtils.shared.persistentContainer.viewContext.fetch(fetchRequest)
            return country.count > 0 ? country[0] : nil
        }
        catch {
            print("Error while fetching pagination info from Core Data")
            return nil
        }
    }
}
