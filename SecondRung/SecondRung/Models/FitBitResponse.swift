//
//  FitBitResponse.swift
//  SecondRung
//
//  Created by Emma O'Keeffe on 24/03/2019.
//  Copyright © 2019 O'Keeffe, Emma. All rights reserved.
//

struct FitBitResponse: Codable{
    let foods: [Food]
    let summary: Summary
}

struct Food: Codable {
    let isFavorite: Bool
    let logDate: String
    let logId: Int
    let loggedFood: LoggedFood
    let nutritionalValues: NutritionalValues
}

struct LoggedFood: Codable {
    let accessLevel: String
    let amount: Int
    let brand: String
    let calories: Int
    let foodId: Int
    let locale: String
    let mealTypeId: Int
    let name: String
    let unit: Unit
    let units: [Int]
}

struct NutritionalValues: Codable {
    let calories: Int
    let carbs: Float
    let fat: Float
    let fiber: Float
    let protein: Float
    let sodium: Int
}

struct Unit: Codable {
    let id: Int
    let name : String
    let plural: String
}

struct Summary: Codable {
    let calories: Int
    let carbs: Float
    let fat: Float
    let fiber: Float
    let protein: Float
    let sodium: Int
    let water: Int
}
