//
//  PlayerSelectionViewController.swift
//  Hasami Shogi
//
//  Created by George McDonnell on 01/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class PlayerSelectionTableViewController: UITableViewController {

    let unregisteredPlayers = ["Player 1" , "Player 2"]
    var playerNames = NSMutableArray()
    var playButton: UIBarButtonItem?


    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        presentViewController(boardViewController, animated: true, completion: nil)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return unregisteredPlayers.count
        } else {
            return 0
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

        cell.textLabel?.text = unregisteredPlayers[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        let playerName = (cell.textLabel?.text)!
        if (playerNames.count != 2 && indexPath.section == 0) {
            if (playerNames.containsObject(playerName)) {
                playerNames.removeObject(playerName)
                cell.accessoryType = UITableViewCellAccessoryType.None
            } else {
                playerNames.addObject(playerName)
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            
        } else if (playerNames.count != 2) {
            //playerNames.append(register[indexPath.row])
            //cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            if (playerNames.containsObject(playerName)) {
                playerNames.removeObject(playerName)
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        
        if (playerNames.count == 2) {
            playButton!.enabled = true
        } else {
            playButton!.enabled = false
        }
    
    }

}
