//
//  BaseViewModel.swift
//  A List
//
//  Created by Jamone Alexander Kelly on 2/20/16.
//  Copyright © 2016 A List. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewModel {
    
    // MARK: Properties
    var postAlertController = PublishSubject<UIAlertController>()
    
    // MARK: AlertType enum
    enum AlertType {
        case Success(String)
        case Error(String)
    }
    
    func showAlert(asType type: AlertType, title: String, options: [UIAlertAction]) {
        switch type {
        case .Success(let message):
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            options.forEach { alertController.addAction($0) }
            postAlertController.on(.Next(alertController))
        case .Error(let message):
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            options.forEach { alertController.addAction($0) }
            postAlertController.on(.Next(alertController))
        }
    }
}
