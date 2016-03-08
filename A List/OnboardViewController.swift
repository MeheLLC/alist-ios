//
//  OnboardViewController.swift
//  A List
//
//  Created by Jamone Alexander Kelly on 2/21/16.
//  Copyright © 2016 A List. All rights reserved.
//

import UIKit

class onBoardViewController: BaseViewController {
    
    // MARK: Properties
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    // MARK: Lifecycle
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set image background for time of day
        backgroundImage.image = UIImage(named: "DayView")
        backgroundView.alpha = 0.6
        
        iconImageView.image = UIImage(named: "Icon")
        
        navigationController!.navigationBar.hidden = !navigationController!.navigationBar.hidden
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController!.navigationBar.hidden = !navigationController!.navigationBar.hidden
    }
}