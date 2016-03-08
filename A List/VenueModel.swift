//
//  VenueModel.swift
//  A List
//
//  Created by Jamone Alexander Kelly on 2/21/16.
//  Copyright © 2016 A List. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: Initializer and Properties
struct venueModel: Mappable {
    
    var venueID: Int!
    var venueName: String!
    var venueAddress: String!
    
    
    // MARK: JSON
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        venueID <- map["venues.id"]
        venueName <- map["venues.name"]
        venueAddress <- map["venues.address"]
    }
}
