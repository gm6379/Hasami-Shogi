//
//  Game.swift
//  Hasami Shogi
//
//  Created by george mcdonnell on 06/10/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class Game: NSObject {
    
    static let sharedInstance = Game()
    
    enum GameStyle: Int {
        case HasamiShogi, DaiHasamiShogi
    }
    
    let PLAYER_1 = 1
    let PLAYER_2 = 2
    
    var currentPlayer = 1
    var style = GameStyle.DaiHasamiShogi
    
    var numberOfStartPieces: Int {
        get {
            return style == .HasamiShogi ? 9 : 18
        }
    }
    var numberOfCapturedPiecesToWin = 1
    
    func checkForWinner(board: Board) -> Int? {
        if (currentPlayer == PLAYER_1 && numberOfStartPieces - board.getNumberOfBlackCells() == numberOfCapturedPiecesToWin) {
            return PLAYER_1
        } else if (currentPlayer == PLAYER_2 && numberOfStartPieces - board.getNumberOfWhiteCells() == numberOfCapturedPiecesToWin) {
            return PLAYER_2
        } else {
            return nil
        }
    }
    
    func checkForWinner(piecesInARow: [Int]) -> Int? {
        if (piecesInARow.contains(5)) {
            if (currentPlayer == PLAYER_1) {
                return PLAYER_1
            } else {
                return PLAYER_2
            }
        }
                
        return nil
    }
    
}
