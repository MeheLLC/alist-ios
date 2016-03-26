//
//  AuthDataManager.swift
//  A List
//
//  Created by Jamone Alexander Kelly on 2/21/16.
//  Copyright © 2016 A List. All rights reserved.
//

import RxSwift
import Moya

enum AuthState {
    case Error(String)
    case None
    case Success(String)
}

class AuthDataManager {
    static var userStatus = Variable(AuthState.None)
    
    private init() {}
    
    static func signup(email: String, password: String) -> Observable<AuthState> {
        return Observable.create { observe in
            APIProvider.request(.AuthEmailSignup(email: email, password: password)).subscribe { event -> Void in
                print("Signup: \(event)")
                switch event {
                case .Next(let user):
                    let json = try! user.mapJSON()
                    print(json)
                    if let status = json["status"] as? Bool {
                        if status {
                            // User exist, save remember_token
                            if let token = json["remember_token"] as? String {
                                PersistencyManager.saveSession(token: token)
                                observe.on(.Next(AuthState.Success("Success")))
                                observe.on(.Completed)
                            } else {
                                observe.on(.Next(AuthState.Error("Server Error")))
                                observe.on(.Completed)
                            }
                        } else {
                            observe.on(.Next(AuthState.Error("User not found")))
                            observe.on(.Completed)
                        }
                    }
                case .Error(_):
                    observe.on(.Next(AuthState.Error("Server Error")))
                    observe.on(.Completed)
                default:
                    observe.on(.Next(AuthState.None))
                    observe.on(.Completed)
                }
            }
        }
    }
    
    static func signin(email: String, password: String) -> Observable<AuthState> {
        return Observable.create { observe in
            APIProvider.request(AListAPI.AuthEmailSignin(email: email, password: password)).subscribe { event -> Void in
                switch event {
                case .Next(let user):
                    let json = try! user.mapJSON()
                    if let status = json["status"] as? Bool {
                        if status {
                            // User exist, save remember_token
                            if let token = json["remember_token"] as? String {
                                PersistencyManager.saveSession(token: token)
                                observe.on(.Next(AuthState.Success("Success")))
                                observe.on(.Completed)
                            } else {
                                observe.on(.Next(AuthState.Error("Server Error")))
                                observe.on(.Completed)
                            }
                        } else {
                            observe.on(.Next(AuthState.Error("User not found")))
                            observe.on(.Completed)
                        }
                    }
                case .Error(_):
                    observe.on(.Next(AuthState.Error("Server Error")))
                    observe.on(.Completed)
                default:
                    observe.on(.Next(AuthState.None))
                    observe.on(.Completed)
                }
            }
        }
    }
    
    static func signinFacebook(email: String, userID: String) -> Observable<AuthState> {
        return Observable.create { observe in
            APIProvider.request(AListAPI.AuthFacebook(email: email, userID: userID)).subscribe { event -> Void in
                switch event {
                case .Next(let data):
                    let json = try! data.mapJSON()
                    
                    print(data)
                case .Error(_):
                    observe.on(.Next(AuthState.Error("Server Error")))
                    observe.on(.Completed)
                default:
                    observe.on(.Next(AuthState.None))
                    observe.on(.Completed)
                }
            }
        }
    }
}