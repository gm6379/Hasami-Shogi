//
//  ViewController.swift
//  Hasami Shogi
//
//  Created by George McDonnell on 30/11/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ViewController: UIViewController, CNContactPickerDelegate {

    
    @IBAction func contacts(sender: UIButton) {
        
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self;
        contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        
        self.presentViewController(contactPicker, animated: true, completion: nil)
    }
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        
    }

}
