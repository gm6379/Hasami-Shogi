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
        case MoveDirectionUp, MoveDirectionDown, MoveDirectionRight, MoveDirectionLeft
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
    
    public func drawPieceInCell(cell: BoardCollectionViewCell, withState state:BoardCollectionViewCell.BoardCellState) {
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
    
    // moves piece from origin to destination cell
    public func movePieceFromCell(originCell: BoardCollectionViewCell, toDestinationCell destinationCell: BoardCollectionViewCell) -> Bool {
        
        drawPieceInCell(destinationCell, withState: originCell.state)
        removePieceFromCell(originCell)
        
        return true
    }
    
    // works out if a move is legal
    public func isMoveLegalFromOriginCell(originCell: BoardCollectionViewCell, atIndexPath origin: NSIndexPath, toDestinationCell destinationCell: BoardCollectionViewCell, atIndexPath destination: NSIndexPath) -> Bool {
        // check for a diagonal move
        if (origin.section != destination.section && origin.item != destination.item) {
            return false
        } else { // check for a collision
            let direction = self.moveDirectionFrom(origin, toDestinationIndexPath: destination)
            
            var currentIndexPath = nextIndexPathInMoveDirection(direction, currentIndexPath: origin)
            var cell: BoardCollectionViewCell = cellForItemAtIndexPath(currentIndexPath) as! BoardCollectionViewCell
            while cell.state == BoardCollectionViewCell.BOARD_CELL_STATE_EMPTY && !cell.isEqual(destinationCell) {
                currentIndexPath = nextIndexPathInMoveDirection(direction, currentIndexPath: currentIndexPath)
                cell = cellForItemAtIndexPath(currentIndexPath) as! BoardCollectionViewCell
            }
            
            if (cell.isEqual(destinationCell)) {
                return true
            } else {
                return false
            }
        }
    }
    
    // does move result in a capture
    public func captureOccurredAtCell(cell: BoardCollectionViewCell, atIndexPath indexPath: NSIndexPath) -> Bool {
        // determine if any of the immediate cells around the current contain the opposite piece color
        let directions = determineCaptureSearchDirectionsForCell(cell, indexPath: indexPath)
        if (directions.isEmpty) {
            return false
        } else {
            // search directions for capture
            for direction in directions {
                var currentIndexPath = nextIndexPathInMoveDirection(direction, currentIndexPath: indexPath);
                var currentCell: BoardCollectionViewCell = cellForItemAtIndexPath(currentIndexPath) as! BoardCollectionViewCell
                
                var edgeOfBoard: Int
                if (direction == .MoveDirectionUp || direction == .MoveDirectionLeft) {
                    edgeOfBoard = 0
                } else {
                    edgeOfBoard = 8;
                }
                
                if (direction == .MoveDirectionUp || direction == .MoveDirectionDown) {
                    while currentCell.state != cell.state && currentIndexPath.section != edgeOfBoard {
                        currentIndexPath = nextIndexPathInMoveDirection(direction, currentIndexPath: currentIndexPath)
                        currentCell = cellForItemAtIndexPath(currentIndexPath) as! BoardCollectionViewCell
                    }
                } else {
                    while currentCell.state != cell.state && currentIndexPath.row != edgeOfBoard {
                        currentIndexPath = nextIndexPathInMoveDirection(direction, currentIndexPath: currentIndexPath)
                        currentCell = cellForItemAtIndexPath(currentIndexPath) as! BoardCollectionViewCell
                    }
                }
                
                if (currentCell.state == cell.state) {
                    return true
                } else {
                    return false
                }
            }
        }
        
        
        return true
    }
    
    // determine directions to iterate
    private func determineCaptureSearchDirectionsForCell(cell: BoardCollectionViewCell, indexPath: NSIndexPath) -> Array<MoveDirection> {
        let cellAbove = cellForItemAtIndexPath(nextIndexPathInMoveDirection(.MoveDirectionUp, currentIndexPath: indexPath)) as! BoardCollectionViewCell
        let cellBelow = cellForItemAtIndexPath(nextIndexPathInMoveDirection(.MoveDirectionDown, currentIndexPath: indexPath))  as! BoardCollectionViewCell
        let cellLeft = cellForItemAtIndexPath(nextIndexPathInMoveDirection(.MoveDirectionLeft, currentIndexPath: indexPath))  as! BoardCollectionViewCell
        let cellRight = cellForItemAtIndexPath(nextIndexPathInMoveDirection(.MoveDirectionRight, currentIndexPath: indexPath))  as! BoardCollectionViewCell
        let cells = [cellAbove,  cellBelow, cellLeft, cellRight]
        var directions = [MoveDirection]()
        for var i = 0; i < cells.count; i++ {
            let surroundingCell = cells[i];
            // check if the cell contains opposing piece
            if ((           cell.state == BoardCollectionViewCell.BOARD_CELL_STATE_BLACK_PIECE &&
                 surroundingCell.state == BoardCollectionViewCell.BOARD_CELL_STATE_WHITE_PIECE) ||
                           (cell.state == BoardCollectionViewCell.BOARD_CELL_STATE_WHITE_PIECE &&
                 surroundingCell.state == BoardCollectionViewCell.BOARD_CELL_STATE_BLACK_PIECE)) {
                switch (i) {
                    case 0: directions.append(.MoveDirectionUp)
                    case 1: directions.append(.MoveDirectionDown)
                    case 2: directions.append(.MoveDirectionLeft)
                    case 3: directions.append(.MoveDirectionRight)
                    default:
                        break
                }
            }
        }
        
        return directions
    }
    
    private func moveDirectionFrom(origin: NSIndexPath, toDestinationIndexPath destination: NSIndexPath) -> MoveDirection {
        if (origin.section == destination.section) { // a horizontal move
            if (origin.row < destination.row) {
                return .MoveDirectionRight;
            } else {
                return .MoveDirectionLeft;
            }
        } else { // a vertical move
            if (origin.section < destination.section) {
                return .MoveDirectionDown;
            } else {
                return .MoveDirectionUp;
            }
        }
    }
    
    private func nextIndexPathInMoveDirection(direction: MoveDirection, currentIndexPath current: NSIndexPath) -> NSIndexPath {
        let indexPath: NSIndexPath
        switch (direction) {
        case .MoveDirectionUp:
            indexPath = NSIndexPath(forItem: current.item, inSection: current.section - 1)
        case .MoveDirectionDown:
            indexPath = NSIndexPath(forItem: current.item, inSection: current.section + 1)
        case .MoveDirectionLeft:
            indexPath = NSIndexPath(forItem: current.item - 1, inSection: current.section)
        case .MoveDirectionRight:
            indexPath = NSIndexPath(forItem: current.item + 1, inSection: current.section)
        }
        
        return indexPath
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        allowsMultipleSelection = true
    }
}
