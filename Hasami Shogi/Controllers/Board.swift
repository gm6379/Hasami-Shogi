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
    private var numberOfWhiteCells: Int = Game.sharedInstance.style == .HasamiShogi ? 9 : 18
    private var numberOfBlackCells: Int = Game.sharedInstance.style == .HasamiShogi ? 9 : 18
    
    private enum Direction {
        case DirectionNorth, DirectionNorthEast, DirectionEast, DirectionSouthEast, DirectionSouth, DirectionSouthWest, DirectionWest, DirectionNorthWest
    }
    
    private let directions = [Direction.DirectionNorth, .DirectionSouth, .DirectionWest, .DirectionEast, .DirectionNorthEast, .DirectionNorthWest, .DirectionSouthEast, .DirectionSouthWest]
    private let moveDirections = [Direction.DirectionNorth, .DirectionSouth, .DirectionWest, .DirectionEast]

    public func getNumberOfWhiteCells() -> Int {
        return numberOfWhiteCells
    }
    
    public func getNumberOfBlackCells() -> Int {
        return numberOfBlackCells
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
            var cell: BoardCollectionViewCell = cellForItemAtIndexPath(currentIndexPath!) as! BoardCollectionViewCell
            while cell.state == BoardCollectionViewCell.BOARD_CELL_STATE_EMPTY && !cell.isEqual(destinationCell) {
                currentIndexPath = nextIndexPathInMoveDirection(direction, currentIndexPath: currentIndexPath!)
                cell = cellForItemAtIndexPath(currentIndexPath!) as! BoardCollectionViewCell
            }
            
            if (cell.isEqual(destinationCell)) {
                return true
            } else {
                return false
            }
        }
    }
    
    // return cells that can be captured from the specified cell
    public func capturableCellsFromCell(cell: BoardCollectionViewCell, atIndexPath indexPath: NSIndexPath) -> Array<BoardCollectionViewCell>? {
        // determine if any of the immediate cells around the current contain the opposite piece color
        let directions = determineSearchDirectionsForCell(cell, indexPath: indexPath, friendly: false)
        if (directions.isEmpty) {
            return nil
        } else {
            // search directions for capture
            for direction in directions {
                var currentIndexPath = nextIndexPathInMoveDirection(direction, currentIndexPath: indexPath);
                if (currentIndexPath != nil) {
                    var currentCell: BoardCollectionViewCell = cellForItemAtIndexPath(currentIndexPath!) as! BoardCollectionViewCell
                    
                    var oppositeState: BoardCollectionViewCell.BoardCellState
                    if (cell.state == BoardCollectionViewCell.BOARD_CELL_STATE_WHITE_PIECE) {
                        oppositeState = BoardCollectionViewCell.BOARD_CELL_STATE_BLACK_PIECE
                    } else {
                        oppositeState = BoardCollectionViewCell.BOARD_CELL_STATE_WHITE_PIECE;
                    }
                    
                    var edgeOfBoard: Int
                    if (direction == .DirectionNorth || direction == .DirectionWest) {
                        edgeOfBoard = 0
                    } else {
                        edgeOfBoard = 8;
                    }
                    
                    var opposingCells = [BoardCollectionViewCell]()
                    opposingCells.append(currentCell)
                    if (direction == .DirectionNorth || direction == .DirectionSouth) {
                        while currentCell.state == oppositeState && currentIndexPath!.section != edgeOfBoard {
                            currentIndexPath = nextIndexPathInMoveDirection(direction, currentIndexPath: currentIndexPath!)
                            currentCell = cellForItemAtIndexPath(currentIndexPath!) as! BoardCollectionViewCell
                            if (currentCell.state != cell.state) {
                                opposingCells.append(currentCell)
                            }
                        }
                    } else {
                        while currentCell.state == oppositeState && currentIndexPath!.row != edgeOfBoard {
                            currentIndexPath = nextIndexPathInMoveDirection(direction, currentIndexPath: currentIndexPath!)
                            currentCell = cellForItemAtIndexPath(currentIndexPath!) as! BoardCollectionViewCell
                            if (currentCell.state == oppositeState) {
                                opposingCells.append(currentCell)
                            }
                        }
                    }
                    
                    if (currentCell.state == cell.state) {
                        return opposingCells
                    } else {
                        return nil
                    }
                }
                
            }
        }
        
        return nil
    }
    
    // return friendly cells from the specified cell
    public func numberOfFriendlyCellsFromCell(cell: BoardCollectionViewCell, atIndexPath indexPath: NSIndexPath) -> [Int]? {
        let directions = determineSearchDirectionsForCell(cell, indexPath: indexPath, friendly: true)
        if (directions.isEmpty) {
            return nil
        } else {
            var numberOfFriendlyCellsArray = [Int]()
            // search directions for friendly cells
            for direction in directions {
                var currentIndexPath = nextIndexPathInMoveDirection(direction, currentIndexPath: indexPath);
                if (currentIndexPath != nil) {
                    var currentCell: BoardCollectionViewCell = cellForItemAtIndexPath(currentIndexPath!) as! BoardCollectionViewCell
                    
                    var numberOfFriendlyCells = 0
                    
                    var verticalEdge: Int?
                    var horizontalEdge: Int?
                    if (direction == .DirectionNorth ||
                        direction == .DirectionNorthEast ||
                        direction == .DirectionNorthWest) {
                            verticalEdge = 2
                    } else if (direction == .DirectionSouth ||
                        direction == .DirectionSouthEast ||
                        direction == .DirectionSouthWest) {
                        verticalEdge = 6
                    }
                    
                    if (direction == .DirectionWest ||
                        direction == .DirectionNorthWest ||
                        direction == .DirectionSouthWest) {
                        horizontalEdge = 2
                    } else if (direction == .DirectionEast ||
                        direction == .DirectionNorthEast ||
                        direction == .DirectionSouthEast) {
                        horizontalEdge = 6
                    }
                    
                    while (currentCell.state == cell.state && currentIndexPath?.section != horizontalEdge && currentIndexPath?.row != verticalEdge) {
                        currentIndexPath = nextIndexPathInMoveDirection(direction, currentIndexPath: currentIndexPath!)
                        currentCell = cellForItemAtIndexPath(currentIndexPath!) as! BoardCollectionViewCell
                        if (currentCell.state == cell.state) {
                            numberOfFriendlyCells += 1
                        }
                    }
                    
                    numberOfFriendlyCellsArray.append(numberOfFriendlyCells)
                }
            }
            
            return numberOfFriendlyCellsArray
        }
    }
    
    // capture the required pieces
    public func capturePiecesInCells(cells: Array<BoardCollectionViewCell>) {
        for cell in cells {
            if (cell.state == BoardCollectionViewCell.BOARD_CELL_STATE_WHITE_PIECE) {
                numberOfWhiteCells -= 1
            } else {
                numberOfBlackCells -= 1
            }
            removePieceFromCell(cell)
        }
    }
    
    // determine directions to iterate
    private func determineSearchDirectionsForCell(cell: BoardCollectionViewCell, indexPath: NSIndexPath, friendly: Bool) -> [Direction] {
        // create an array of all possible directions
        var possibleDirections: [Direction]
        if (friendly) {
            possibleDirections = self.directions
        } else {
            possibleDirections = moveDirections
        }
        
        // create an array of all cells surrounding current cell, taking into account the edge of the board
        var surroundingCells = [BoardCollectionViewCell?]()
        for direction in possibleDirections {
            let surroundingCellIndexPath = nextIndexPathInMoveDirection(direction, currentIndexPath: indexPath);
            let surroundingCell: BoardCollectionViewCell?
            if (surroundingCellIndexPath != nil) {
                surroundingCell = cellForItemAtIndexPath(surroundingCellIndexPath!) as? BoardCollectionViewCell
                surroundingCells.append(surroundingCell)
            } else {
                surroundingCells.append(nil)
            }
        }
        
        // determine directions to search for friendly / capturable cells
        var directions = [Direction]()
        for var i = 0; i < surroundingCells.count; i++ {
            let surroundingCell = surroundingCells[i];
            if (surroundingCell != nil) {
                // check if the cell contains an opposing piece
                if ((!friendly && cell.state == BoardCollectionViewCell.BOARD_CELL_STATE_BLACK_PIECE &&
                      surroundingCell!.state == BoardCollectionViewCell.BOARD_CELL_STATE_WHITE_PIECE) ||
                                 (cell.state == BoardCollectionViewCell.BOARD_CELL_STATE_WHITE_PIECE &&
                      surroundingCell!.state == BoardCollectionViewCell.BOARD_CELL_STATE_BLACK_PIECE)) {
                     appendDirection(i, directions: &directions)
                } else if (friendly && cell.state == surroundingCell!.state) {
                    appendDirection(i, directions: &directions)
                }
            }
        }
        
        return directions
    }
    
    private func appendDirection(direction: Int, inout directions: [Direction]) {
        switch (direction) {
            case 0: directions.append(.DirectionNorth)
            case 1: directions.append(.DirectionSouth)
            case 2: directions.append(.DirectionWest)
            case 3: directions.append(.DirectionEast)
            case 4: directions.append(.DirectionNorthEast)
            case 5: directions.append(.DirectionNorthWest)
            case 6: directions.append(.DirectionSouthEast)
            case 7: directions.append(.DirectionSouthWest)
            default:
                break
        }
    }
    
    private func moveDirectionFrom(origin: NSIndexPath, toDestinationIndexPath destination: NSIndexPath) -> Direction {
        if (origin.section == destination.section) { // a horizontal move
            if (origin.row < destination.row) {
                return .DirectionEast;
            } else {
                return .DirectionWest;
            }
        } else { // a vertical move
            if (origin.section < destination.section) {
                return .DirectionSouth;
            } else {
                return .DirectionNorth;
            }
        }
    }
    
    private func nextIndexPathInMoveDirection(direction: Direction, currentIndexPath current: NSIndexPath) -> NSIndexPath? {
        var indexPath: NSIndexPath?
        switch (direction) {
        case .DirectionNorth:
            if (current.section > 0) {
                indexPath = NSIndexPath(forItem: current.item, inSection: current.section - 1)
            }
        case .DirectionSouth:
            if (current.section < 8) {
                indexPath = NSIndexPath(forItem: current.item, inSection: current.section + 1)
            }
        case .DirectionWest:
            if (current.row > 0) {
                indexPath = NSIndexPath(forItem: current.item - 1, inSection: current.section)
            }
        case .DirectionEast:
            if (current.row < 8) {
                indexPath = NSIndexPath(forItem: current.item + 1, inSection: current.section)
            }
        case .DirectionNorthEast:
            if (current.section > 0  && current.row < 8) {
                indexPath = NSIndexPath(forItem: current.item + 1, inSection: current.section - 1)
            }
        case .DirectionNorthWest:
            if (current.section > 0 && current.row > 0) {
                indexPath = NSIndexPath(forItem: current.item - 1, inSection: current.section - 1)
            }
        case .DirectionSouthEast:
            if (current.section < 8 && current.row < 8) {
                indexPath = NSIndexPath(forItem: current.item + 1, inSection: current.section + 1)
            }
        case .DirectionSouthWest:
            if (current.section < 8 && current.row > 0) {
                indexPath = NSIndexPath(forItem: current.item - 1, inSection: current.section + 1)
            }
        }
        
        return indexPath
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        allowsMultipleSelection = true
    }
}
