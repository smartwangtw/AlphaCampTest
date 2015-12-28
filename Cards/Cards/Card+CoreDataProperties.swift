//
//  Card+CoreDataProperties.swift
//  Cards
//
//  Created by WANGMING-LIANG on 12/28/15.
//  Copyright © 2015 Fone Shaking. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Card {

    @NSManaged var desc: String?
    @NSManaged var image: NSData?
    @NSManaged var title: String?
    @NSManaged var addTime: NSDate?

}
