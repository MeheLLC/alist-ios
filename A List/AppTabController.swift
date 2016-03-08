//
//  AppTabController.swift
//  A List
//
//  Created by Jamone Alexander Kelly on 2/21/16.
//  Copyright © 2016 A List. All rights reserved.
//

import UIKit
import FontAwesomeKit

class AppTabController: UITabBarController {
    
    // MARK: Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabs: [UITabBarItem] = self.tabBar.items {
            let feed: UITabBarItem = tabs[0] as UITabBarItem
            let map: UITabBarItem = tabs[1] as UITabBarItem
            let qr: UITabBarItem = tabs[2] as UITabBarItem
            let add: UITabBarItem = tabs[3] as UITabBarItem
            
            feed.image = FAKFontAwesome.boltIconWithSize(25).imageWithSize(CGSize(width: 25, height: 25))
            map.image = FAKFontAwesome.globeIconWithSize(25).imageWithSize(CGSize(width: 25, height: 25))
            qr.image = FAKFontAwesome.qrcodeIconWithSize(25).imageWithSize(CGSize(width: 25, height: 25))
            add.image = FAKFontAwesome.plusIconWithSize(25).imageWithSize(CGSize(width: 25, height: 25))
        }
    }
}
