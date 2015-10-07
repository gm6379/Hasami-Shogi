//
//  ViewController.swift
//  Hasami Shogi
//
//  Created by George McDonnell on 28/09/2015.
//  Copyright © 2015 George McDonnell. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var originIndexPath: NSIndexPath?
    //var destinationIndexPath: NSIndexPath?
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
        
        if (indexPath.section == 0) {
            Board.drawPieceInCell(cell, withState: BoardCollectionViewCell.BOARD_CELL_STATE_WHITE_PIECE)
        } else if (indexPath.section == 8) {
            Board.drawPieceInCell(cell, withState: BoardCollectionViewCell.BOARD_CELL_STATE_BLACK_PIECE)
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
        print(selectedCells!)
        
        // if cell is only cell selected
        // and cell has a piece in
        if (selectedCells?.count == 1 && cell.state != BoardCollectionViewCell.BOARD_CELL_STATE_EMPTY) {
            self.originIndexPath = indexPath
            cell.backgroundColor = UIColor.redColor()
        } else if (selectedCells?.count == 2) { // if two cells are selected
            let destinationIndexPath = indexPath
            // if the first cell is occupied
            let originCell = collectionView.cellForItemAtIndexPath((self.originIndexPath)!) as! BoardCollectionViewCell
            let destinationCell = collectionView.cellForItemAtIndexPath(destinationIndexPath) as! BoardCollectionViewCell
            
            // if origin cell is not empty and destination cell is empty
            if (originCell.state != BoardCollectionViewCell.BOARD_CELL_STATE_EMPTY && destinationCell.state == BoardCollectionViewCell.BOARD_CELL_STATE_EMPTY) {
                // attempt to move piece from the origin to the destination
                if (Board.movePieceFromCell(originCell, toDestinationCell: destinationCell)) {
                    // move successful
                    collectionView.deselectItemAtIndexPath(self.originIndexPath!, animated: false)
                    collectionView.deselectItemAtIndexPath(destinationIndexPath, animated: false)
                } else {
                    // illegal move
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