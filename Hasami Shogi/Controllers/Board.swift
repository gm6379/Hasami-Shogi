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
    
    
    public static func movePieceFromCell(originCell: BoardCollectionViewCell, toDestinationCell destinationCell: BoardCollectionViewCell) -> Bool {
        Board.drawPieceInCell(destinationCell, withState: originCell.state)
        self.removePieceFromCell(originCell)
        
        return true
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        allowsMultipleSelection = true
    }
}
