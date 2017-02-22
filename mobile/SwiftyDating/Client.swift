//
//  Client.swift
//  SwiftyDating
//
//  Created by Maxime De Sogus on 21/02/2017.
//  Copyright © 2017 Maxime De Sogus. All rights reserved.
//

import Foundation
import JSONJoy

struct Client : JSONJoy {
    let token: String
    
    init(_ decoder: JSONDecoder) throws {
        token = try decoder["token"].get()
        
        //just an example of "checking" for a property.
        if let meta: String = decoder["meta"].getOptional() {
            print("found some meta info: \(meta)")
        }
    }
}
