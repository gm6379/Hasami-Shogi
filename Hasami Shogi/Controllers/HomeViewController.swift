//
//  HomeViewController.swift
//  Hasami Shogi
//
//  Created by George McDonnell on 01/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }    
    
    @IBAction func register(sender: UIButton) {
        let registerViewController = storyboard?.instantiateViewControllerWithIdentifier("RegisterViewController")
        presentViewController(registerViewController!, animated: false, completion: nil)
    }
    
    
}
