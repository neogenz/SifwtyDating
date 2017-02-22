//
//  PeopleMeet.swift
//  SwiftyDating
//
//  Created by Maxime De Sogus on 21/02/2017.
//  Copyright © 2017 Maxime De Sogus. All rights reserved.
//

import Foundation
class PeopleMeet{
    var id:Int? = 0;
    var firstname:String = ""
    var lastname:String = ""
    var birthdate: Date
    var note: Int
    var sexe: Gender
    
    init(){
        id = 0
        firstname = "Inconnue"
        lastname = "Inconnue"
        birthdate = Date()
        sexe = Gender.MAN
        note = 1
    }
    
    init(firstname:String, lastname:String, birthdate:Date, sexe:String, note:Int){
        self.firstname = firstname
        self.lastname = lastname
        self.birthdate = birthdate
        self.note = note
        if let gender = Gender(rawValue: sexe){
            self.sexe = gender
        }else{
            self.sexe = Gender.MAN
        }
    }
    
    init(id:Int, firstname:String, lastname:String, birthdate:Date, sexe:String, note:Int){
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.birthdate = birthdate
        self.note = note
        if let gender = Gender(rawValue: sexe){
            self.sexe = gender
        }else{
            self.sexe = Gender.MAN
        }
    }
}
