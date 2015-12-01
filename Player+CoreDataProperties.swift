//
//  Player+CoreDataProperties.swift
//  Hasami Shogi
//
//  Created by George McDonnell on 01/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import Foundation
import CoreData

extension Player {

    @NSManaged var avatar: NSData?
    @NSManaged var name: String?
    @NSManaged var score: NSNumber?
    @NSManaged var pDescription: String?

}
