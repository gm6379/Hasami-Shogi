//
//  Player+CoreDataProperties.swift
//  Hasami Shogi
//
//  Created by George McDonnell on 01/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Player {

    @NSManaged var avatar: NSData?
    @NSManaged var forename: String?
    @NSManaged var pDescription: String?
    @NSManaged var score: NSNumber?
    @NSManaged var surname: String?

}
