//
//  AuthenticationHelpers.swift
//  SwiftyDating
//
//  Created by Maxime De Sogus on 21/02/2017.
//  Copyright © 2017 Maxime De Sogus. All rights reserved.
//

import Foundation
import SwiftHTTP
import CryptoSwift
import JSONJoy

protocol AuthenticationServiceDelegate{
    func didChallenged(challenge: String);
    func challengeDidVerified(token: String);
    func didFail(UXMessage:String);
    func didSignedUp(token:String);
}

class AuthenticationService{
    static var sharedInstance = AuthenticationService();
    
    private init(){}
    
    func getChallenge(by email:String, password:String, delegate:AuthenticationServiceDelegate){
        let body = ["email": email]
        do{
            let opt = try HTTP.POST("\(Config.baseURL)/randomkey", parameters: body)
            opt.start { response in
                if response.error != nil {
                    var httpError:HttpError
                    do{
                        httpError = try HttpError(JSONDecoder(response.data))
                    }catch{
                        print(error)
                        httpError = HttpError()
                        httpError.message = "Erreur inconnue."
                    }
                    
                    DispatchQueue.main.async {
                        delegate.didFail(UXMessage: httpError.message)
                    }
                    return
                }
                let json = try? JSONSerialization.jsonObject(with: response.data, options: [])
                if let dictionary = json as? [String: Any] {
                    if let randomkey = dictionary["randomkey"] as? String{
                        let challenge = String(randomkey + email + password).md5()
                        DispatchQueue.main.async {
                            delegate.didChallenged(challenge: challenge)
                        }
                        
                    }
                }
            }
        }catch{
            print(error)
        }
    }
    
    func verifyChallenge(by challenge:String, email:String, delegate:AuthenticationServiceDelegate){
        let body = ["email": email, "token": challenge]
        do{
            let opt = try HTTP.POST("\(Config.baseURL)/signin", parameters: body)
            opt.start { response in
                if response.error != nil {
                    var httpError:HttpError
                    do{
                        httpError = try HttpError(JSONDecoder(response.data))
                    }catch{
                        print(error)
                        httpError = HttpError()
                        httpError.message = "Erreur inconnue."
                    }
                    
                    DispatchQueue.main.async {
                        delegate.didFail(UXMessage: httpError.message)
                    }
                    return
                }
                let json = try? JSONSerialization.jsonObject(with: response.data, options: [])
                /*if let dictionary = json as? [String: Any] {
                 if let randomkey = dictionary["randomkey"] as? String{*/
                DispatchQueue.main.async {
                    delegate.challengeDidVerified(token: "todo")
                    /*}
                     
                     }*/
                }
            }
        }catch{
            print(error)
        }
        
    }
    
    
    func signup(by email:String, username:String, password:String, delegate: AuthenticationServiceDelegate){
        let body = ["email": email, "username": username, "password": password]
        do{
            let opt = try HTTP.POST("\(Config.baseURL)/signup", parameters: body)
            opt.start { response in
                if response.error != nil {
                    var httpError:HttpError
                    do{
                        httpError = try HttpError(JSONDecoder(response.data))
                    }catch{
                        print(error)
                        httpError = HttpError()
                        httpError.message = "Erreur inconnue."
                    }
                    
                    DispatchQueue.main.async {
                        delegate.didFail(UXMessage: httpError.message)
                    }
                    return
                }
                DispatchQueue.main.async {
                    delegate.didSignedUp(token: "todo")
                }
            }
        }catch{
            print(error)
        }
    }
}
