//
//  SignupWithEmail.swift
//  A List
//
//  Created by Jamone Alexander Kelly on 2/21/16.
//  Copyright © 2016 A List. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignupWithEmail: BaseViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet var backgroundView: UIView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    var alertController: UIAlertController? {
        didSet {
            self.presentViewController(alertController!, animated: true, completion: nil)
        }
    }
    
    var viewModel: signupViewModel!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Localizable("Sign up")
        
        viewModel = signupViewModel(email: emailTextField.rx_text.asDriver(), password: passwordTextField.rx_text.asDriver(), confirmPass: confirmPasswordTextField.rx_text.asDriver())
        
        viewModel.postAlertController.subscribeNext{ alert in
            self.alertController = alert
            }.addDisposableTo(disposeBag)
        
        viewModel.infoValid
            .driveNext { [unowned self] valid in
                self.signUpButton.enabled = valid
                self.signUpButton.enabled ? self.signUpButton.setTitleColor(.whiteColor(), forState: .Normal) : self.signUpButton.setTitleColor(.grayColor(), forState: .Normal)
            }
            .addDisposableTo(disposeBag)
        
        signUpButton.rx_tap
            .withLatestFrom(viewModel.infoValid)
            .filter { $0 }
            .flatMapLatest { [unowned self] valid -> Observable<AuthState> in
                self.viewModel.signup(self.emailTextField.text!, password: self.passwordTextField.text!)
                    .observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Default))
            }
            .observeOn(MainScheduler.instance)
            .subscribeNext { [unowned self] autenticationStatus in
                AWLoader.hide()
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
                AuthDataManager.userStatus.value = autenticationStatus
            }
            .addDisposableTo(disposeBag)
    }
    
    func presentFeed() {
        let appStoryboard: UIStoryboard = UIStoryboard(name: "App", bundle: nil)
        
        let rootViewController: UITabBarController = appStoryboard.instantiateViewControllerWithIdentifier("appTabBar") as! UITabBarController
        
        self.presentViewController(rootViewController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        backgroundView.frame = view.frame
        
        // Set image background for time of day
        backgroundImage.image = UIImage(named: "DayView")
        backgroundView.alpha = 0.6
        
        iconImageView.image = UIImage(named: "Icon")
        
        if let nav = navigationController {
            nav.navigationBar.hidden = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //navigationController!.navigationBar.hidden = !navigationController!.navigationBar.hidden
    }
}
