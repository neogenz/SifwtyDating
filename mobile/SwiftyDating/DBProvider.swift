//
//  DBProvider.swift
//  SwiftyDating
//
//  Created by Maxime De Sogus on 21/02/2017.
//  Copyright © 2017 Maxime De Sogus. All rights reserved.
//

import Foundation
import SQLite

class DBProvider {
    private init(){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fm:FileManager = FileManager.default;
        if(!fm.fileExists(atPath: "\(path)/swiftydating.db")){
            print("Le fichier n'existe pas ");
        }
        do {
            try connection = Connection("\(path)/swiftydating.db")
            print("DB create at : \(path)/swiftydating.db")
        } catch {
            connection = nil
            print(Error.self)
        }
    }
    
    static var sharedInstance = DBProvider();
    
    var connection:Connection?
}
