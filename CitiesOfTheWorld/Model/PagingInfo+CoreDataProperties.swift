//
//  PagingInfo+CoreDataProperties.swift
//  CitiesOfTheWorld
//
//  Created by Jorge Sirvent on 24/7/18.
//  Copyright © 2018 Jorge Sirvent. All rights reserved.
//
//

import Foundation
import CoreData


extension PagingInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PagingInfo> {
        return NSFetchRequest<PagingInfo>(entityName: "PagingInfo")
    }

    @NSManaged public var lastPage: Int16
    @NSManaged public var lastCachedPage: Int16

}
