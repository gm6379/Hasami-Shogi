//
//  BoardCollectionViewCell.swift
//  Hasami Shogi
//
//  Created by george mcdonnell on 06/10/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

public class BoardCollectionViewCell: UICollectionViewCell {

    public enum BoardCellState {
        case BoardCellStateEmpty, BoardCellStateBlackPiece, BoardCellStateWhitePiece
    }
    
    public static let BOARD_CELL_STATE_EMPTY = BoardCellState.BoardCellStateEmpty
    public static let BOARD_CELL_STATE_BLACK_PIECE = BoardCellState.BoardCellStateBlackPiece
    public static let BOARD_CELL_STATE_WHITE_PIECE = BoardCellState.BoardCellStateWhitePiece
    
    var state: BoardCellState = BoardCellState.BoardCellStateEmpty
    var pieceView: UIView?
}
