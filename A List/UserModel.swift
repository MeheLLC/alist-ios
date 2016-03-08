//
//  UserModel.swift
//  A List
//
//  Created by Jamone Alexander Kelly on 2/21/16.
//  Copyright © 2016 A List. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: Initializer and Properties
struct userModel: Mappable {
    
    var userID: Int!
    var rememberToken: String!
    //var expiryString: String?
    
    
    // MARK: JSON
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        userID <- map["userID"]
        rememberToken <- map["remember_token"]
        //expiryString <- map["expiryString"]
    }
}