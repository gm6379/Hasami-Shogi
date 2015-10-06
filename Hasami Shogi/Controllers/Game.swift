//
//  Game.swift
//  Hasami Shogi
//
//  Created by george mcdonnell on 06/10/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class Game: NSObject {
    
    enum GameStyle {
        case HasamiShogi, DaHasamiShogi
    }
    
    let PLAYER_1 = 1
    let PLAYER_2 = 2
    
    var currentPlayer = 0    
}
