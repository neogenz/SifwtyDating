//
//  Constants.swift
//  SwiftyDating
//
//  Created by Maxime De Sogus on 21/02/2017.
//  Copyright © 2017 Maxime De Sogus. All rights reserved.
//

import Foundation
import UIKit

struct Config {
    static let baseURL = NSURL(string: "http://172.20.10.2:3000")!
}

struct Color {
    static let primaryColor = UIColor(red: 0.22, green: 0.58, blue: 0.29, alpha: 1.0)
    static let secondaryColor = UIColor.lightGray
}

enum FormMode: Int {
    case ADD, EDIT
}
