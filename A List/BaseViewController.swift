//
//  BaseViewController.swift
//  A List
//
//  Created by Jamone Alexander Kelly on 2/19/16.
//  Copyright © 2016 A List. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
}
