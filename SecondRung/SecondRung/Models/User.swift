//
//  User.swift
//  SecondRung
//
//  Created by Emma O'Keeffe on 26/01/2019.
//  Copyright © 2019 O'Keeffe, Emma. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uuid, firstName, lastName, gender, dateOfBirth : String
    let age : Int
    var calciumRDA = 0
    var vitARDA = 0
    var vitCRDA = 0
    var ironRDA = 0
    let potassRDA = 3500
    
    init(uuid: String, firstName: String, lastName: String, gender: String, dateOfBirth: String, age: Int) {
        self.uuid = uuid
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.dateOfBirth = dateOfBirth
        self.age = age
    }
    
    mutating func setRDA () {
        
        if self.age >= 18 && self.age <= 24 {
            self.calciumRDA = 1000
        } else {
            self.calciumRDA = 950
        }
        
        if self.gender == "f" {
            self.vitARDA = 650
            self.vitCRDA = 95
            if self.age >= 18 && self.age <= 39 {
                self.ironRDA = 16
            } else {
                self.ironRDA = 11
            }
        } else {
            self.vitARDA = 750
            self.vitCRDA = 110
            self.ironRDA = 11
        }
    }
}

