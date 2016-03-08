//
//  AListAPI.swift
//  A List
//
//  Created by Jamone Alexander Kelly on 2/21/16.
//  Copyright © 2016 A List. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire

typealias UserLocation = (x: Double, y: Double)

enum AListAPI {
    // MARK: - User
    case AuthEmailSignup(email: String, password: String)
    case AuthEmailSignin(email: String, password: String)
    
    // MARK: - Venues
    case VenueList(location: UserLocation, distance: Int)
    case VenueCreate([String: AnyObject])
}

// MARK: - Provider support

extension AListAPI: TargetType {
    
    var path: String {
        switch self {
        case .AuthEmailSignin(_, _):
            return "/api/v1/user/signin"
        case .AuthEmailSignup(_, _):
            return "/api/v1/user/signup"
            
        case .VenueList(_, let distance):
            return "/api/v1/venues/list/\(distance)"
        case .VenueCreate(_):
            return "/api/v1/venues/create"
        }
    }
    
    var parameters: [String: AnyObject]? {
        switch self {
        case .AuthEmailSignup(let email, let password):
            return ["type": "email",
                "email": email,
                "password": password
            ]
        case .AuthEmailSignin(let email, let password):
            return ["type": "email",
                "email": email,
                "password": password
            ]
            
        case .VenueList(let location, _):
            return ["location[x]": location.x,
            "location[y]": location.y
            ]
        case .VenueCreate(let data):
            return data
        }
    }
    
    var baseURL: NSURL { return NSURL(string: "https://alist-dev.herokuapp.com")! }
    
    var method: Moya.Method {
        switch self {
        case .AuthEmailSignin(_, _), .AuthEmailSignup(_, _), .VenueList(_, _), .VenueCreate(_):
            return .POST
        }
    }
    
    var sampleData: NSData {
        switch self {
        case .AuthEmailSignup(_, _):
            return "{\"status\": \"true\", \"msg\": \"User created\", \"remember_token\": \"A3G383GD\"}".dataUsingEncoding(NSUTF8StringEncoding)!
        case .AuthEmailSignin(_, _):
            return "{\"status\": \"true\", \"msg\": \"Login success\", \"remember_token\": \"A3G383GD\"}".dataUsingEncoding(NSUTF8StringEncoding)!
        case .VenueList(_, _):
            return "{\"status\": \"true\", \"venues\": {\"id\": \"1\", \"name\": \"Speak easy\", \"address\": \"6th street ave, Austin, TX\"}}".dataUsingEncoding(NSUTF8StringEncoding)!
        case .VenueCreate(_):
            return "{\"status\": \"true\", \"msg\": \"Venue added\"}".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
}

private extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
}

func url(route: TargetType) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}