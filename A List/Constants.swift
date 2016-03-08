//
//  Constants.swift
//  A List
//
//  Created by Jamone Alexander Kelly on 2/21/16.
//  Copyright © 2016 A List. All rights reserved.
//

import Foundation
import Moya

// MARK: API Constants
let endpointClosure = { (target: AListAPI) -> Endpoint<AListAPI> in
    return Endpoint<AListAPI>(URL: url(target), sampleResponseClosure: {.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
}
//let APIProvider = RxMoyaProvider(endpointClosure: endpointClosure)
let APIProvider = RxMoyaProvider<AListAPI>()

// MARK: Persistency Manager

struct PersistencyManager {
    
    static func saveSession(token token: String) {
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: "userToken")
        print("Saved token: \(token)")
    }
    
    static func clearSession() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userToken")
    }
}