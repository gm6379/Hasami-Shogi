//
//  LeagueTableViewController.swift
//  Hasami Shogi
//
//  Created by George McDonnell on 01/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class LeagueTableViewController: UITableViewController {
    
    let dataController = CoreDataController()
    var registeredPlayers: [Player] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registeredPlayers = dataController.fetchPlayers()
        self.navigationController?.navigationBarHidden = false
        self.title = "League Table"
        
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "dismiss")
        navigationItem.leftBarButtonItem = backButton
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registeredPlayers.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        
        let player = registeredPlayers[indexPath.row]
        
        cell.textLabel?.text = player.forename! + " " + player.surname!
        cell.detailTextLabel?.text = player.score?.stringValue

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let playerDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("PlayerDetailViewController") as! PlayerDetailViewController
        playerDetailViewController.player = registeredPlayers[indexPath.row]
        showViewController(playerDetailViewController, sender: self)
    }
    
    @IBAction func dismiss() {
        dismissViewControllerAnimated(false, completion: nil)
    }
    
}
