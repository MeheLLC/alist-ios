//
//  LoginWithEmailVC.swift
//  A List
//
//  Created by Jamone Alexander Kelly on 2/19/16.
//  Copyright © 2016 A List. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginWithEmailVC: BaseViewController {
    
    // MARK: Properties
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.placeholder = Localizable("Email").uppercaseString
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.placeholder = Localizable("Password").uppercaseString
        }
    }
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var backgroundView: UIView!
    
    var alertController: UIAlertController? {
        didSet {
            self.presentViewController(alertController!, animated: true, completion: nil)
        }
    }
    
    var viewModel: loginViewModel!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Localizable("Sign In")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowOrHide:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowOrHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Up", style: UIBarButtonItemStyle.Plain, target: self, action: "presentSignup:")
        
        viewModel = loginViewModel(email: emailTextField.rx_text.asDriver(), password: passwordTextField.rx_text.asDriver())
        
        viewModel.postAlertController.subscribeNext{ alert in
            self.alertController = alert
        }.addDisposableTo(disposeBag)
        
        viewModel.infoValid
            .driveNext { [unowned self] valid in
                self.loginButton.enabled = valid
                self.loginButton.enabled ? self.loginButton.setTitleColor(.whiteColor(), forState: .Normal) : self.loginButton.setTitleColor(.grayColor(), forState: .Normal)
            }
            .addDisposableTo(disposeBag)
        
        loginButton.rx_tap
            .withLatestFrom(viewModel.infoValid)
            .filter { $0 }
            .flatMapLatest { [unowned self] valid -> Observable<AuthState> in
                self.viewModel.login(self.emailTextField.text!, password: self.passwordTextField.text!)
                    .observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Default))
            }
            .observeOn(MainScheduler.instance)
            .subscribeNext { [unowned self] autenticationStatus in
                switch autenticationStatus {
                case .Success(_):
                    self.presentFeed()
                case .Error(let error):
                    self.viewModel.showAlert(asType: .Error(error), title: "Error", options: [UIAlertAction(title: "Dismiss", style: .Default, handler: nil)])
                case .None:
                    let alertController = UIAlertController(title: "Bad credentials", message: "Unable to login", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                AuthDataManager.sharedManager.userStatus.value = autenticationStatus
            }
            .addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set image background for time of day
        backgroundImageView.image = UIImage(named: "DayView")
        backgroundView.alpha = 0.6
        
        iconImageView.image = UIImage(named: "Icon")
    }
    
}

// MARK: - UITextField Delegate -

extension LoginWithEmailVC: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UIKeyboard Notification -

extension LoginWithEmailVC {
    
    private struct ButtonProperties {
        static let margin: CGFloat = 10.0
    }
    
    func keyboardWillShowOrHide(notification: NSNotification) {
        let keyboardBeginFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardEndFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        // IF the keyboard is moving
        if keyboardBeginFrame != keyboardEndFrame {
            
            /*
            If the login button is not on top of keyboard ( loginButton.frame.minY > keyboardEndFrame.minY  ), we put it above
            Else, we put it on the bottom of the view ( `margin` from the bottom )
            */
            let constantBottom: CGFloat = loginButton.frame.minY > keyboardEndFrame.minY ? keyboardEndFrame.height + ButtonProperties.margin : ButtonProperties.margin
            
            UIView.animateWithDuration(0.5, animations: {
                self.loginButtonBottomConstraint.constant         = constantBottom
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func presentSignup(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("loginToSignup", sender: self)
    }
    
    func presentFeed() {
        let appStoryboard: UIStoryboard = UIStoryboard(name: "App", bundle: nil)
        
        let rootViewController: UITabBarController = appStoryboard.instantiateViewControllerWithIdentifier("appTabBar") as! UITabBarController
        
        self.presentViewController(rootViewController, animated: true, completion: nil)
    }
}