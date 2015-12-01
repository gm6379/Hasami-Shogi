//
//  HomeViewController.swift
//  Hasami Shogi
//
//  Created by George McDonnell on 01/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBAction func newGame(sender: UIButton) {
        let boardViewController = storyboard?.instantiateViewControllerWithIdentifier("BoardViewController")
        presentViewController(boardViewController!, animated: true, completion: nil)
    }
    
    
    @IBAction func register(sender: UIButton) {
        let registerViewController = storyboard?.instantiateViewControllerWithIdentifier("RegisterViewController")
        presentViewController(registerViewController!, animated: true, completion: nil)
    }
}
