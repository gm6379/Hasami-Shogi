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


}

extension BoardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 9;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BoardCollectionViewCell", forIndexPath: indexPath)
        cell.layer.borderColor = UIColor.blackColor().CGColor
        cell.layer.borderWidth = 1.0
        
        if (indexPath.section == 0) {
            drawPieceWithColor(UIColor.whiteColor(), inView: cell)
        } else if (indexPath.section == 8) {
            drawPieceWithColor(UIColor.blackColor(), inView: cell)
        }
        let boardColor = UIColor(red: 237 / 255, green: 160 / 255, blue: 91/255, alpha: 1)
        cell.backgroundColor = boardColor

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath);
        cell?.backgroundColor = UIColor.redColor()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.size.width / 9, collectionView.frame.size.height / 9)
    }
    
    func drawPieceWithColor(color: UIColor, inView view: UIView) {
        let piece = UIView(frame: CGRectMake(0, 0, view.frame.size.width, view.frame.size.height))
        piece.layer.cornerRadius = piece.frame.size.width / 2
        piece.layer.masksToBounds = true
        
        piece.backgroundColor = color
        
        if (color == UIColor.whiteColor()) {
            piece.layer.borderWidth = 1.0
            piece.layer.borderColor = UIColor.blackColor().CGColor
        }
        
        view.addSubview(piece)
    }
}