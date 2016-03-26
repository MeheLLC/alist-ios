//
//  OnboardViewController.swift
//  A List
//
//  Created by Jamone Alexander Kelly on 2/21/16.
//  Copyright © 2016 A List. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Crashlytics
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit

class onBoardViewController: BaseViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var facebookButton: UIButton!
    
    @IBOutlet weak var twitterButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        facebookButton.addTarget(self, action: #selector(onBoardViewController.callFB(_:)), forControlEvents: .TouchUpInside)
        twitterButton.addTarget(self, action: #selector(onBoardViewController.callTwitter(_:)), forControlEvents: .TouchUpInside)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func callFB(sender: UIButton) {
        // This will move to the ViewModel
        let login = FBSDKLoginManager()
        login.logInWithReadPermissions(["email"], fromViewController: self, handler: {(result, error) -> Void in
            if error != nil {
                // Handle error
                NSLog("Login error: %s", error.description)
            } else if result.isCancelled {
                // Handle cancellations
                NSLog("Login cancelled")
            } else {
                if result.grantedPermissions.contains("email") {
                    let token = FBSDKAccessToken.currentAccessToken().tokenString
                    print("Facebook Token: \(token)")
                    
                    // Check if email exists in the backend
                    
                    
                    let appStoryboard: UIStoryboard = UIStoryboard(name: "App", bundle: nil)
                    
                    let rootViewController: UITabBarController = appStoryboard.instantiateViewControllerWithIdentifier("appTabBar") as! UITabBarController
                    
                    self.presentViewController(rootViewController, animated: true, completion: nil)
                    //Crashlytics.sharedInstance().crash()
                } else {
                    print("Error: Unable to retrieve email from FB")
                }
            }
        })
    }
    
    func callTwitter(sender: UIButton) {
        // ViewModel as well
        Twitter.sharedInstance().logInWithCompletion { session, error in
            if (session != nil) {
                print("signed in as \(session!.userName) ID: \(session!.userID)");
                
                // Check if user exists in the backend 
                
            } else {
                print("error: \(error!.localizedDescription)");
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the background based on the time
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([ .Hour, .Minute, .Second], fromDate: date)
        let hour = components.hour
        
        print("Hour: \(hour)")
        
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