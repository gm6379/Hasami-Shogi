//
//  ViewController.swift
//  Hasami Shogi
//
//  Created by George McDonnell on 28/09/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

protocol BoardViewControllerDelgate {
    func willDismiss()
}

class BoardViewController: UIViewController, SettingsViewControllerDelegate {
    
    @IBOutlet weak var player1Indicator: BoardCollectionViewCell!
    @IBOutlet weak var player1NameLabel: UILabel!
    @IBOutlet weak var player2NameLabel: UILabel!
    @IBOutlet weak var player2Indicator: BoardCollectionViewCell!
    @IBOutlet weak var board: Board!
    var currentPlayer: Int = Game.sharedInstance.currentPlayer
    
    var player1: String?
    var player1IsRegistered: Bool?
    var player2: String?
    var player2IsRegistered: Bool?
    
    let dataController = CoreDataController()
    
    var gameHasBegun = false
    
    var numPiecesToWin: Int?
    var numStartPieces: Int?
    var fivePieceRule: Bool?
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    var delegate: BoardViewControllerDelgate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        player1NameLabel.text = player1?.componentsSeparatedByString(" ")[0]
        player2NameLabel.text = player2?.componentsSeparatedByString(" ")[0]
        
        board.drawPieceInCell(player1Indicator, withState: BoardCollectionViewCell.BOARD_CELL_STATE_WHITE_PIECE)
        player1Indicator.layer.borderWidth = 1.0
        board.drawPieceInCell(player2Indicator, withState: BoardCollectionViewCell.BOARD_CELL_STATE_BLACK_PIECE)
        player2Indicator.layer.borderWidth = 1.0
        
        highlightCurrentPlayer()
    }

    var originIndexPath: NSIndexPath?
    
    func updateCurrentPlayer() {
        if (currentPlayer == Game.sharedInstance.PLAYER_1) {
            Game.sharedInstance.currentPlayer = Game.sharedInstance.PLAYER_2
        } else {
            Game.sharedInstance.currentPlayer = Game.sharedInstance.PLAYER_1
        }
        currentPlayer = Game.sharedInstance.currentPlayer
        highlightCurrentPlayer()
    }
    
    func highlightCurrentPlayer() {
        let currentPlayer = Game.sharedInstance.currentPlayer
        if (currentPlayer == Game.sharedInstance.PLAYER_1) {
            player1Indicator.layer.borderColor = UIColor.redColor().CGColor
            player2Indicator.layer.borderColor = UIColor.clearColor().CGColor
        } else {
            player2Indicator.layer.borderColor = UIColor.redColor().CGColor
            player1Indicator.layer.borderColor = UIColor.clearColor().CGColor
        }
    }
    
    @IBAction func restartGame() {
        if (numPiecesToWin != nil && numStartPieces != nil && fivePieceRule != nil) {
            Game.sharedInstance.style = numStartPieces == 9 ? Game.GameStyle.HasamiShogi : Game.GameStyle.DaiHasamiShogi
            Game.sharedInstance.numberOfCapturedPiecesToWin = numPiecesToWin!
            Game.sharedInstance.fivePieceRuleEnforced = fivePieceRule!
        }
        board.reloadData()
        Game.sharedInstance.currentPlayer = Game.sharedInstance.PLAYER_1
        currentPlayer = Game.sharedInstance.currentPlayer
        highlightCurrentPlayer()
        gameHasBegun = false
    }
    
    private func displayIllegalMoveError() {
        let alert = UIAlertController(title: "Error", message: "Illegal move", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func displayWinnerMessage(winner: String) {
        let alert = UIAlertController(title: "Winner!", message: "The winner was " + winner, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.restartGame()
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func home(sender: UIButton) {
        if (numPiecesToWin != nil && numStartPieces != nil && fivePieceRule != nil) {
            Game.sharedInstance.style = numStartPieces == 9 ? Game.GameStyle.HasamiShogi : Game.GameStyle.DaiHasamiShogi
            Game.sharedInstance.numberOfCapturedPiecesToWin = numPiecesToWin!
            Game.sharedInstance.fivePieceRuleEnforced = fivePieceRule!
        }
        Game.sharedInstance.currentPlayer = Game.sharedInstance.PLAYER_1

        delegate?.willDismiss()
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func leagueTable(sender: AnyObject) {
        let leagueTableViewController = storyboard?.instantiateViewControllerWithIdentifier("LeagueTableNavigationController") as! UINavigationController
        
        presentViewController(leagueTableViewController, animated: false, completion: nil)
    }
    
    @IBAction func settings(sender: UIButton) {
        let settingsNavController = storyboard?.instantiateViewControllerWithIdentifier("SettingsNavigationController") as! UINavigationController
        let root = settingsNavController.viewControllers[0] as! SettingsViewController
        root.delegate = self
        root.tempNumStartPieces = numStartPieces
        root.tempNumPiecesToWin = numPiecesToWin
        root.tempFivePieceRule = fivePieceRule
        presentViewController(settingsNavController, animated: false, completion: nil)
    }

    func settingsDidChange(numStartPieces: Int, numPiecesToWin: Int, fivePieceRuleEnforced: Bool) {
        if (gameHasBegun) {
            self.numStartPieces = numStartPieces
            self.numPiecesToWin = numPiecesToWin
            self.fivePieceRule = fivePieceRuleEnforced
        } else {
            self.numStartPieces = nil
            self.numPiecesToWin = nil
            self.fivePieceRule = nil
            Game.sharedInstance.style = numStartPieces == 9 ? Game.GameStyle.HasamiShogi : Game.GameStyle.DaiHasamiShogi
            Game.sharedInstance.numberOfCapturedPiecesToWin = numPiecesToWin
            Game.sharedInstance.fivePieceRuleEnforced = fivePieceRuleEnforced
            restartGame()
        }
    }
    
}

extension BoardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 9;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BoardCollectionViewCell", forIndexPath: indexPath) as! BoardCollectionViewCell
        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.layer.borderWidth = 1.0
        
        board.removePieceFromCell(cell)
        if (Game.sharedInstance.style == Game.GameStyle.HasamiShogi) {
            if (indexPath.section == 0) {
                board.drawPieceInCell(cell, withState: BoardCollectionViewCell.BOARD_CELL_STATE_WHITE_PIECE)
            } else if (indexPath.section == 8) {
                board.drawPieceInCell(cell, withState: BoardCollectionViewCell.BOARD_CELL_STATE_BLACK_PIECE)
            }
        } else {
            if (indexPath.section == 0 || indexPath.section == 1) {
                board.drawPieceInCell(cell, withState: BoardCollectionViewCell.BOARD_CELL_STATE_WHITE_PIECE)
            } else if (indexPath.section == 7 || indexPath.section == 8) {
                board.drawPieceInCell(cell, withState: BoardCollectionViewCell.BOARD_CELL_STATE_BLACK_PIECE)
            }
        }
        
        cell.backgroundColor = Board.COLOR

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = Board.COLOR
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! BoardCollectionViewCell;
        let selectedCells = collectionView.indexPathsForSelectedItems()
        
        // current player can only select his/her pieces
        // player 1 = white
        // player 2 = black
        var currentPlayerState: BoardCollectionViewCell.BoardCellState
        if (currentPlayer == Game.sharedInstance.PLAYER_1) {
            currentPlayerState = BoardCollectionViewCell.BOARD_CELL_STATE_WHITE_PIECE
        } else {
            currentPlayerState = BoardCollectionViewCell.BOARD_CELL_STATE_BLACK_PIECE
        }
        
        // if cell is only cell selected
        // and cell has a piece in
        if (selectedCells?.count == 1 && cell.state == currentPlayerState) {
            self.originIndexPath = indexPath
            cell.backgroundColor = UIColor.redColor()
        } else if (selectedCells?.count == 2) { // if two cells are selected
            let destinationIndexPath = indexPath
            // if the first cell is occupied
            let originCell = collectionView.cellForItemAtIndexPath((self.originIndexPath)!) as! BoardCollectionViewCell
            let destinationCell = collectionView.cellForItemAtIndexPath(destinationIndexPath) as! BoardCollectionViewCell
            
            let board = collectionView as! Board
            
            // if origin cell is not empty and destination cell is empty
            if (originCell.state != BoardCollectionViewCell.BOARD_CELL_STATE_EMPTY && destinationCell.state == BoardCollectionViewCell.BOARD_CELL_STATE_EMPTY) {
                // attempt to move piece from the origin to the destination
                if (board.isMoveLegalFromOriginCell(originCell, atIndexPath: originIndexPath!, toDestinationCell: destinationCell, atIndexPath: destinationIndexPath)) {
                    gameHasBegun = true
                    // move successful
                    board.movePieceFromCell(originCell, toDestinationCell: destinationCell)
                    collectionView.deselectItemAtIndexPath(self.originIndexPath!, animated: false)
                    collectionView.deselectItemAtIndexPath(destinationIndexPath, animated: false)
                    
                    // check for capture
                    let capturableCells = board.capturableCellsFromCell(destinationCell, atIndexPath: destinationIndexPath)
                    if (capturableCells != nil) {
                        // capture necessary pieces
                        board.capturePiecesInCells(capturableCells!)
                        
                        let winner = Game.sharedInstance.checkForWinner(board)
                        if (winner != nil) {
                            if (winner == Game.sharedInstance.PLAYER_1) {
                                displayWinnerMessage(player1!)
                                if (player1IsRegistered! && player2IsRegistered!) {
                                    dataController.updatePlayerScoreWithName(player1!)
                                }
                            } else {
                                displayWinnerMessage(player2!)
                                if (player1IsRegistered! && player2IsRegistered!) {
                                    dataController.updatePlayerScoreWithName(player2!)
                                }
                            }
                        }
                    }
                    
                    if (Game.sharedInstance.style == Game.GameStyle.DaiHasamiShogi && Game.sharedInstance.fivePieceRuleEnforced && destinationIndexPath.section > 1 && destinationIndexPath.section < 7) {
                        let friendlyCells = board.numberOfFriendlyCellsFromCell(destinationCell, atIndexPath: destinationIndexPath)
                        if (friendlyCells != nil) {
                            let winner = Game.sharedInstance.checkForWinner(friendlyCells!)
                            
                            if (winner != nil) {
                                if (winner == Game.sharedInstance.PLAYER_1) {
                                    displayWinnerMessage(player1!)
                                    if (player1IsRegistered! && player2IsRegistered!) {
                                        dataController.updatePlayerScoreWithName(player1!)
                                    }
                                } else {
                                    displayWinnerMessage(player2!)
                                    if (player1IsRegistered! && player2IsRegistered!) {
                                        dataController.updatePlayerScoreWithName(player2!)
                                    }
                                }
                            }
                        }
                    }
                    
                    // update current player
                    updateCurrentPlayer()
                } else {
                    // illegal move
                    originCell.backgroundColor = Board.COLOR
                    collectionView.deselectItemAtIndexPath(self.originIndexPath!, animated: false)
                    collectionView.deselectItemAtIndexPath(destinationIndexPath, animated: false)
                    displayIllegalMoveError()
                }
            } else {
                // illegal move
                originCell.backgroundColor = Board.COLOR
                collectionView.deselectItemAtIndexPath(self.originIndexPath!, animated: false)
                collectionView.deselectItemAtIndexPath(destinationIndexPath, animated: false)
                displayIllegalMoveError()
            }
        } else { // deselect the cell
            cell.backgroundColor = Board.COLOR
            collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.size.width / 9, collectionView.frame.size.height / 9)
    }
    
}