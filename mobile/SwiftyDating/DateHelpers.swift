//
//  DateHelpers.swift
//  SwiftyDating
//
//  Created by Maxime De Sogus on 21/02/2017.
//  Copyright © 2017 Maxime De Sogus. All rights reserved.
//

import Foundation
class DateHelpers{
    
    static var sharedInstance:DateHelpers = DateHelpers()
    
    private init(){}
    
    func getTimeIntervalBy(year: Int) -> TimeInterval{
        return TimeInterval(60 * 60 * 24 * (year*365))
    }
}
