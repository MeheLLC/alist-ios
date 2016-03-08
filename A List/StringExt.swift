//
//  StringExt.swift
//  A List
//
//  Created by Jamone Alexander Kelly on 2/21/16.
//  Copyright © 2016 A List. All rights reserved.
//

import Foundation

// MARK: - Rules -

private struct Regex {
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
}

extension String {
    var isEmailValid: Bool {
        let regex = Regex.email
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluateWithObject(self)
    }
}