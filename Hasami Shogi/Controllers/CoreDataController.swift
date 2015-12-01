//
//  CoreDataController.swift
//  Hasami Shogi
//
//  Created by George McDonnell on 01/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject {

    func fetchPlayers() -> [Player] {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Player")
        let sortDescriptor = NSSortDescriptor(key: "score", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let players = try context.executeFetchRequest(request) as! [Player]
            return players
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    func createPlayer(playerForename: String, playerSurname: String, playerDescription: String?, playerAvatar: NSData) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let player: Player = NSEntityDescription.insertNewObjectForEntityForName("Player", inManagedObjectContext: appDelegate.managedObjectContext) as! Player
        player.forename = playerForename
        player.surname = playerSurname
        player.pDescription = playerDescription
        player.avatar = playerAvatar
        appDelegate.saveContext()
    }
}
