//
//  ViewController.swift
//  Hasami Shogi
//
//  Created by George McDonnell on 28/09/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController {
    
    @IBOutlet weak var player1Indicator: BoardCollectionViewCell!
    @IBOutlet weak var player2Indicator: BoardCollectionViewCell!
    @IBOutlet weak var board: Board!
    var currentPlayer: Int = Game.sharedInstance.currentPlayer

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        
        //let board = collectionView as! Board
        
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
        let i = collectionView.indexPathsForSelectedItems()?.first
        print(i)
        print(i?.section)
        print(i?.item)
        
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
                    // move successful
                    board.movePieceFromCell(originCell, toDestinationCell: destinationCell)
                    collectionView.deselectItemAtIndexPath(self.originIndexPath!, animated: false)
                    collectionView.deselectItemAtIndexPath(destinationIndexPath, animated: false)
                    
                    // check for capture
                    let capturableCells = board.capturableCellsFromCell(destinationCell, atIndexPath: destinationIndexPath)
                    if (capturableCells != nil) {
                        // capture necessary pieces
                        board.capturePiecesInCells(capturableCells!)
                    }
                    
                    // update current player
                    updateCurrentPlayer()
                } else {
                    // illegal move
                    originCell.backgroundColor = Board.COLOR
                    collectionView.deselectItemAtIndexPath(self.originIndexPath!, animated: false)
                    collectionView.deselectItemAtIndexPath(destinationIndexPath, animated: false)
                }
            } else {
                // illegal move
                originCell.backgroundColor = Board.COLOR
                collectionView.deselectItemAtIndexPath(self.originIndexPath!, animated: false)
                collectionView.deselectItemAtIndexPath(destinationIndexPath, animated: false)
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