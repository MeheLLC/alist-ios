//
//  SignupViewModel.swift
//  A List
//
//  Created by Jamone Alexander Kelly on 2/21/16.
//  Copyright © 2016 A List. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class signupViewModel: BaseViewModel {
    
    let infoValid: Driver<Bool>
    
    init(email: Driver<String>, password: Driver<String>) {
        let emailValid = email
            .distinctUntilChanged()
            .throttle(0.3)
            .map { $0.isEmailValid }
        
        let passwordValid = password
            .distinctUntilChanged()
            .throttle(0.3)
            .map { $0.utf8.count > 5 }
        
        self.infoValid = Driver.combineLatest(emailValid, passwordValid) { $0 && $1 }
    }
    
    func signup(email: String, password: String) -> Observable<AuthState> {
        return AuthDataManager.sharedManager.signup(email, password: password)
    }
}