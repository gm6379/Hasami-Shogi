//
//  PlayerSelectionViewController.swift
//  Hasami Shogi
//
//  Created by George McDonnell on 01/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class PlayerSelectionTableViewController: UITableViewController, BoardViewControllerDelgate {

    let unregisteredPlayers = ["Player 1" , "Player 2"]
    var playerNames = NSMutableArray()
    var playButton: UIBarButtonItem?

    let dataController = CoreDataController()
    var registeredPlayers: [Player] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registeredPlayers = dataController.fetchPlayers()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.title = "Choose your players"
        
        playButton = UIBarButtonItem(title: "Play!", style: UIBarButtonItemStyle.Plain, target: self, action: "play")
        playButton!.enabled = false
        self.navigationItem.rightBarButtonItem = playButton
    }
    
    func play() {
        let boardViewController = storyboard?.instantiateViewControllerWithIdentifier("BoardViewController") as! BoardViewController
        boardViewController.player1 = playerNames[0] as? String
        boardViewController.player2 = playerNames[1] as? String
        boardViewController.delegate = self
        presentViewController(boardViewController, animated: false, completion: nil)
    }
    
    func willDismiss() {
        navigationController?.popViewControllerAnimated(false)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return unregisteredPlayers.count
        } else {
            return registeredPlayers.count
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Unregistered Players"
        } else {
            return "Registered Players"
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        
        if (indexPath.section == 0) {
            cell.textLabel?.text = unregisteredPlayers[indexPath.row]
        } else {
            let player = registeredPlayers[indexPath.row]
            cell.textLabel?.text = player.forename! + " " + player.surname!
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        let playerName = (cell.textLabel?.text)!
        let forename = playerName.componentsSeparatedByString(" ")[0]
        if (playerNames.count != 2) {
            if (indexPath.section == 1 && playerNames.containsObject(forename)) {
                playerNames.removeObject(forename)
                cell.accessoryType = UITableViewCellAccessoryType.None
            } else if (indexPath.section == 0 && playerNames.containsObject(playerName)) {
                playerNames.removeObject(playerName)
                cell.accessoryType = UITableViewCellAccessoryType.None
            } else {
                if (indexPath.section == 1) {
                    playerNames.addObject(forename)
                } else {
                    playerNames.addObject(playerName)
                }
                
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        } else {
            if (indexPath.section == 1 && playerNames.containsObject(forename)) {
                playerNames.removeObject(forename)
            } else if (indexPath.section == 0 && playerNames.containsObject(playerName)) {
                playerNames.removeObject(playerName)
            }
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        if (playerNames.count == 2) {
            playButton!.enabled = true
        } else {
            playButton!.enabled = false
        }
    }
    
    
}
