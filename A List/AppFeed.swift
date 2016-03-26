//
//  AppFeed.swift
//  A List
//
//  Created by Jamone Alexander Kelly on 2/21/16.
//  Copyright © 2016 A List. All rights reserved.
//

import UIKit
import Crashlytics

class AppFeed: UICollectionViewController {
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        loadActiveRxFeed()
    }
    
    func loadActiveRxFeed() {
        print("Feed")
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! FeedCells
        
        cell.venueAddress.text = ""
        cell.venueName.text = ""
        
        return cell
    }
    
}
