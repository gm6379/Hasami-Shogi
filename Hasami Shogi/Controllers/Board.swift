//
//  Board.swift
//  Hasami Shogi
//
//  Created by george mcdonnell on 06/10/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

public class Board: UICollectionView {
    
    public static let COLOR = UIColor(red: 237 / 255, green: 160 / 255, blue: 91/255, alpha: 1)
    private static let NUMBER_OF_CELLS = 81
    private var numberOfWhiteCells: Int?
    private var numberOfBlackCells: Int?

    public func getNumberOfWhiteCells() -> Int {
        return numberOfWhiteCells!
    }
    
    public func setNumberOfWhiteCells(number: Int) {
        numberOfWhiteCells = number
    }
    
    public func getNumberOfBlackCells() -> Int {
        return numberOfBlackCells!
    }
    
    public func setNumberOfBlackCells(number: Int) {
        numberOfBlackCells = number
    }
    
    public static func drawPieceInCell(cell: BoardCollectionViewCell, withState state:BoardCollectionViewCell.BoardCellState) {
        let piece = UIView(frame: CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height))
        piece.layer.cornerRadius = piece.frame.size.width / 2
        piece.layer.masksToBounds = true
        
        if (state == BoardCollectionViewCell.BOARD_CELL_STATE_WHITE_PIECE) {
            piece.backgroundColor = UIColor.whiteColor()
            piece.layer.borderWidth = 1.0
            piece.layer.borderColor = UIColor.blackColor().CGColor
        } else {
            piece.backgroundColor = UIColor.blackColor()
        }
        
        cell.state = state
        cell.addSubview(piece)
        cell.pieceView = piece
    }
    
    static func removePieceFromCell(cell: BoardCollectionViewCell) {
        cell.pieceView?.removeFromSuperview()
        cell.state = BoardCollectionViewCell.BOARD_CELL_STATE_EMPTY
        cell.backgroundColor = Board.COLOR
    }
    
    // returns true if the move is legal
    // returns false if the move is illegal
    public static func movePieceFromCell(originCell: BoardCollectionViewCell, toDestinationCell destinationCell: BoardCollectionViewCell) -> Bool {
        
        Board.drawPieceInCell(destinationCell, withState: originCell.state)
        self.removePieceFromCell(originCell)
        
        return true
    }
    
    // works out if a move is legal
    public func isMoveLegalFromOriginIndexPath(origin: NSIndexPath, toDestinationIndexPath destination: NSIndexPath) -> Bool {
        // check for a diagonal move
        if (origin.section != destination.section &&
            origin.item != destination.item) {
            return false
        } else { // check for a collision
            // obtain reference to cells on the route to the destination are occupied
            let indexPaths: [NSIndexPath]
            
            if (origin.section == destination.section) { // a horizontal move
                
            } else { // a vertical move
                
            }
        }
        
        return true
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        allowsMultipleSelection = true
    }
}
