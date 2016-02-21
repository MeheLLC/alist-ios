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
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Localizable("Sign In")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowOrHide:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowOrHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        let emailValidation     = emailTextField.rx_text.map { self.isEmailValid($0) }
        let passwordValidation  = passwordTextField.rx_text.map { !$0.isEmpty }
        
        let signInButtonEnabled = Observable.combineLatest(emailValidation, passwordValidation) { isEmailValid, isPasswordValid in
            return isEmailValid && isPasswordValid
        }
        
        signInButtonEnabled.bindTo(loginButton.rx_enabled).addDisposableTo(disposeBag)
        
    }
    
    // MARK: - Rules -
    
    private struct Regex {
        static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    }
    
    func isEmailValid(email: String) -> Bool {
        let regex = Regex.email
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluateWithObject(email)
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
}