//
//  HttpError.swift
//  SwiftyDating
//
//  Created by Maxime De Sogus on 21/02/2017.
//  Copyright © 2017 Maxime De Sogus. All rights reserved.
//

import Foundation
import JSONJoy

struct HttpError : JSONJoy {
    var code: Int
    var message: String
    var status: String? = ""
    
    init(){
        code = 500;
        message = "Erreur inconnue";
        status = "Inconnue";
    }
    
    init(_ decoder: JSONDecoder) throws {
        code = try decoder["code"].get()
        message = try decoder["message"].get()
        
        //just an example of "checking" for a property.
        if let _status: String = decoder["status"].getOptional() {
            status = _status;
        }
    }
}
