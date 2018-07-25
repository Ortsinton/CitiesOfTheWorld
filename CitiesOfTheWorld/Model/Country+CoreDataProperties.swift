//
//  Country+CoreDataProperties.swift
//  CitiesOfTheWorld
//
//  Created by Jorge Sirvent on 24/7/18.
//  Copyright © 2018 Jorge Sirvent. All rights reserved.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int16
    @NSManaged public var cities: NSSet?

}

// MARK: Generated accessors for cities
extension Country {

    @objc(addCitiesObject:)
    @NSManaged public func addToCities(_ value: City)

    @objc(removeCitiesObject:)
    @NSManaged public func removeFromCities(_ value: City)

    @objc(addCities:)
    @NSManaged public func addToCities(_ values: NSSet)

    @objc(removeCities:)
    @NSManaged public func removeFromCities(_ values: NSSet)

}
