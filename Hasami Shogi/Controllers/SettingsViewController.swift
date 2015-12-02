//
//  SettingsViewController.swift
//  Hasami Shogi
//
//  Created by George McDonnell on 02/12/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func settingsDidChange(numStartPieces: Int, numPiecesToWin: Int, fivePieceRuleEnforced: Bool)
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var numStartPiecesControl: UISegmentedControl!
    @IBOutlet weak var numPiecesToWinStepper: UIStepper!
    @IBOutlet weak var numPiecesToWinLabel: UILabel!
    @IBOutlet var fivePieceRuleViews: [UIView]!
    @IBOutlet weak var fivePieceRuleSwitch: UISwitch!
    
    var tempNumStartPieces: Int?
    var tempNumPiecesToWin: Int?
    var tempFivePieceRule: Bool?
    
    var numStartPieces: Int?
    var numPiecesToWin: Int?
    var fivePieceRule: Bool?
    
    var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numStartPieces = (tempNumStartPieces != nil) ? tempNumStartPieces : Game.sharedInstance.numberOfStartPieces
        numPiecesToWin = (tempNumPiecesToWin != nil) ? tempNumPiecesToWin : Game.sharedInstance.numberOfCapturedPiecesToWin
        fivePieceRule = (tempFivePieceRule != nil) ? tempFivePieceRule : Game.sharedInstance.fivePieceRuleEnforced

        numStartPiecesControl.selectedSegmentIndex = numStartPieces == 9 ? 0 : 1
        
        numPiecesToWinStepper.minimumValue = 1
        numPiecesToWinStepper.maximumValue = numStartPieces == 9 ? 9 : 18
        
        if (numStartPieces == 9) {
            for view in fivePieceRuleViews {
                view.hidden = true
            }
        }

        numPiecesToWinStepper.value = Double(numPiecesToWin!)
        
        numPiecesToWinLabel.text = String(numPiecesToWin!)
        
        fivePieceRule! ? fivePieceRuleSwitch.setOn(true, animated: false) : fivePieceRuleSwitch.setOn(false, animated: false)
        
        let saveButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveSettings")
        navigationItem.rightBarButtonItem = saveButtonItem
        
        let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancel")
        navigationItem.leftBarButtonItem = cancelButtonItem

    }
    
    @IBAction func piecesPerPlayerValueChanged(sender: UISegmentedControl) {
        numStartPieces = numStartPiecesControl.selectedSegmentIndex == 0 ? 9 : 18
        
        if (numStartPieces == 9) {
            for view in fivePieceRuleViews {
                view.hidden = true
            }
        } else {
            for view in fivePieceRuleViews {
                view.hidden = false
            }
        }
        
        numPiecesToWinStepper.maximumValue = numStartPieces == 9 ? 9 : 18
        numPiecesToWinLabel.text = String(Int(numPiecesToWinStepper.value))
    }
    
    @IBAction func piecesToWinStepperValueChanged(stepper: UIStepper) {
        numPiecesToWin = Int(stepper.value)
        numPiecesToWinLabel.text = String(numPiecesToWin!)
    }
    
    @IBAction func fivePieceRuleSwitchValueChanged(sender: UISwitch) {
        fivePieceRule = fivePieceRuleSwitch.on ? true : false
    }

    @IBAction func saveSettings() {
        delegate?.settingsDidChange(numStartPieces!, numPiecesToWin: numPiecesToWin!, fivePieceRuleEnforced: fivePieceRule!)
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func cancel() {
        dismissViewControllerAnimated(false, completion: nil)
    }
}
