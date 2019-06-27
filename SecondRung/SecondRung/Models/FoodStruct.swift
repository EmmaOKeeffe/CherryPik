//
//  FoodStruct.swift
//  SecondRung
//
//  Created by Emma O'Keeffe on 27/03/2019.
//  Copyright © 2019 O'Keeffe, Emma. All rights reserved.
//

import Foundation


struct FoodStruct {
    
    let name : String
    let quantity : String
    var calcium : String
    var vitaminA : String
    var vitaminC : String
    var iron : String
    let potassium : String
    
    init(name: String, quantity : String, calcium : String, vitaminA : String, vitaminC : String, iron : String, potassium : String ) {
        self.name = name
        self.quantity = quantity
        self.calcium = calcium
        self.vitaminA = vitaminA
        self.vitaminC = vitaminC
        self.iron = iron
        self.potassium = potassium
    }
    
}


