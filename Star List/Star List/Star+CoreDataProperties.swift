//
//  Star+CoreDataProperties.swift
//  Star List
//
//  Created by WANGMING-LIANG on 12/25/15.
//  Copyright © 2015 Fone Shaking. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Star {

    @NSManaged var name: String?
    @NSManaged var age: NSNumber?

}
