//
//  Player+CoreDataProperties.swift
//  Hasami Shogi
//
//  Created by George McDonnell on 30/11/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import Foundation
import CoreData

extension Player {

    @NSManaged var avatar: NSData?
    @NSManaged var name: String?
    @NSManaged var pDescription: String?
    @NSManaged var numberOfWins: NSNumber?

}
