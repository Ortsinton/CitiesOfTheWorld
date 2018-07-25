//
//  PagingInfo+CoreDataClass.swift
//  CitiesOfTheWorld
//
//  Created by Jorge Sirvent on 24/7/18.
//  Copyright © 2018 Jorge Sirvent. All rights reserved.
//
//

import Foundation
import CoreData

@objc(PagingInfo)
public class PagingInfo: NSManagedObject {
    public static func getPagingInfo() -> PagingInfo? {
        do {
            if let pagingInfo = try CoreDataUtils.shared.persistentContainer.viewContext.fetch(PagingInfo.fetchRequest()) as? [PagingInfo] {
                return pagingInfo.count == 1 ? pagingInfo[0] : PagingInfo(context: CoreDataUtils.shared.persistentContainer.viewContext)
            }
            return nil
        }
        catch {
            print("Error while fetching pagination info from Core Data")
            return nil
        }
    }
}
