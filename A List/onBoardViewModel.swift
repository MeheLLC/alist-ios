//
//  onBoardViewModel.swift
//  A List
//
//  Created by Jamone Alexander Kelly on 2/21/16.
//  Copyright © 2016 A List. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class onBoardViewModel: BaseViewModel {
    
    func facebookLogin(email: String, userID: String) -> Observable<AuthState> {
        return AuthDataManager.sharedManager.signinFacebook(email, userID: userID)
    }
}