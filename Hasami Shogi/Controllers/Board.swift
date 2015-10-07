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
    
    private enum MoveDirection {
        case Up, Down, Left, Right
    }

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
    
    private func removePieceFromCell(cell: BoardCollectionViewCell) {
        cell.pieceView?.removeFromSuperview()
        cell.state = BoardCollectionViewCell.BOARD_CELL_STATE_EMPTY
        cell.backgroundColor = Board.COLOR
    }

    public func movePieceFromCell(originCell: BoardCollectionViewCell, atIndexPath originIndexPath: NSIndexPath, toDestinationCell destinationCell: BoardCollectionViewCell, atIndexPath destinationIndexPath: NSIndexPath) -> Bool {
        Board.drawPieceInCell(destinationCell, withState: originCell.state)
        removePieceFromCell(originCell)
        
        return true
    }
    
    // returns true if the move is legal
    // returns false if the move is illegal
    public func isMoveLegalFromOriginIndexPath(origin: NSIndexPath, toDestinationIndexPath destination: NSIndexPath) -> Bool {
        // check for a diagonal move
        if (origin.section != destination.section && origin.item != destination.item) {
            return false
        } else { // check for a collision
            if (origin.section == destination.section) { // a horizontal move
                // if  move to the right
                if (destination.item > origin.item) {
                    return !checkCollisionInDirection(.Right, fromOriginIndexPath: origin, toDestinationIndexPath: destination)
                } else { // move is to the left
                    return !checkCollisionInDirection(.Left, fromOriginIndexPath: origin, toDestinationIndexPath: destination)
                }
            } else { // a vertical move
                // if move up
                if (destination.section < origin.section) {
                    return !checkCollisionInDirection(.Up, fromOriginIndexPath: origin, toDestinationIndexPath: destination)
                } else { // move is down
                    return !checkCollisionInDirection(.Down, fromOriginIndexPath: origin, toDestinationIndexPath: destination)
                }
            }
        }
    }
    
    // returns true if a collsion occurs
    // returns false if no collision occurs
    private func checkCollisionInDirection(direction: MoveDirection, fromOriginIndexPath origin: NSIndexPath, toDestinationIndexPath destination: NSIndexPath) -> Bool{
        var state: BoardCollectionViewCell.BoardCellState?

        switch direction {
        case .Up:
            var section = origin.section - 1
            while (!stateIsOccupied(state) && section > destination.section) {
                let cell = cellForItemAtIndexPath(NSIndexPath(forItem: origin.item, inSection: section)) as! BoardCollectionViewCell
                state = cell.state
                section--
            }
        case .Down:
            var section = origin.section + 1
            while (!stateIsOccupied(state) && section < destination.section ) {
                let cell = cellForItemAtIndexPath(NSIndexPath(forItem: origin.item, inSection: section)) as! BoardCollectionViewCell
                state = cell.state
                section++
            }
        case .Right:
            var item = origin.item + 1
            while (!stateIsOccupied(state) && item < destination.item) {
                let cell = cellForItemAtIndexPath(NSIndexPath(forItem: item, inSection: origin.section)) as! BoardCollectionViewCell
                state = cell.state
                item++
            }
        case .Left:
            var item = origin.item - 1
            while (!stateIsOccupied(state) && item > destination.item) {
                let cell = cellForItemAtIndexPath(NSIndexPath(forItem: item, inSection: origin.section)) as! BoardCollectionViewCell
                state = cell.state
                item--
            }
        }
        
        // if an occupied cell is found, move is illegal
        return stateIsOccupied(state)
    }
    
    // returns whether a cell state is occupied
    private func stateIsOccupied(state: BoardCollectionViewCell.BoardCellState?) -> Bool {
        if (state == BoardCollectionViewCell.BOARD_CELL_STATE_WHITE_PIECE
         || state == BoardCollectionViewCell.BOARD_CELL_STATE_BLACK_PIECE) {
            return true
        } else {
            return false
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        allowsMultipleSelection = true
    }
}
