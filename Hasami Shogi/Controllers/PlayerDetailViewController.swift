//
//  PlayerDetailViewController.swift
//  Hasami Shogi
//
//  Created by George McDonnell on 01/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class PlayerDetailViewController: UIViewController {
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var player: Player?

    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()

        self.avatarImageView.image = UIImage(data: (player?.avatar)!)
        self.nameLabel.text = (player?.forename!)! + " " + (player?.surname!)!
        self.descriptionTextView.text = player?.pDescription
    }

}
