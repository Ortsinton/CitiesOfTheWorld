//
//  City+CoreDataProperties.swift
//  CitiesOfTheWorld
//
//  Created by Jorge Sirvent on 24/7/18.
//  Copyright © 2018 Jorge Sirvent. All rights reserved.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var name: String?
    @NSManaged public var localName: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var pageNumber: Int16
    @NSManaged public var id: Int16
    @NSManaged public var country: Country?

}
