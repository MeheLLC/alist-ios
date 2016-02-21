//
//  UIViewExt.swift
//  A List
//
//  Created by Jamone Alexander Kelly on 2/20/16.
//  Copyright © 2016 A List. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor {
        get { return UIColor(CGColor: layer.borderColor!) ?? UIColor() }
        set { layer.borderColor = newValue.CGColor }
    }
    
}