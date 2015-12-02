//
//  RegisterViewController.swift
//  Hasami Shogi
//
//  Created by George McDonnell on 30/11/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import CoreData

class RegisterViewController: UIViewController, CNContactPickerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerShortDescriptionTextView: UITextView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var playerForename: String?
    var playerSurname: String?
    
    let contactPicker = CNContactPickerViewController()
    var shownPicker = false

    override func viewWillAppear(animated: Bool) {
        if (!shownPicker) {
            contactPicker.delegate = self;
            
            self.presentViewController(contactPicker, animated: false, completion: nil)
            shownPicker = true
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: "dismissKeyboard")
        
        self.view.addGestureRecognizer(tap)
    }
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        contactPicker.dismissViewControllerAnimated(false) { () -> Void in
        
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                if (contact.imageData != nil) {
                    self.playerImageView.image = UIImage(data: contact.imageData!)
                }
                
                self.playerImageView.alpha = 1
                self.playerForename = contact.givenName
                self.playerSurname = contact.familyName
                self.playerNameLabel.text = self.playerForename! + " " + self.playerSurname!
                self.playerNameLabel.alpha = 1
                self.playerShortDescriptionTextView.alpha = 1
                self.registerButton.alpha = 1
                self.cancelButton.alpha = 1
            })
        }
    }
    
    func contactPickerDidCancel(picker: CNContactPickerViewController) {
        picker.dismissViewControllerAnimated(false, completion: nil)
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    func dismissKeyboard() {
        playerShortDescriptionTextView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if (textView.text == "Enter a short description here...") {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text == "") {
            textView.text = "Enter a short description here..."
        }
    }
    
    @IBAction func completeRegistration(sender: UIButton) {
        let dataController = CoreDataController()
        var pDescription: String?
        if (playerShortDescriptionTextView.text != "Enter a short description here...") {
            pDescription = playerShortDescriptionTextView.text
        }
        
        let avatar = UIImagePNGRepresentation(playerImageView.image!)
        
        dataController.createPlayer(playerForename!, playerSurname: playerSurname!, playerDescription: pDescription, playerAvatar: avatar!)
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func cancelRegistration(sender: UIButton) {
        dismissViewControllerAnimated(false, completion: nil)
    }
    
}
