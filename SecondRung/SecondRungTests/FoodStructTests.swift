//
//  FoodStructTests.swift
//  SecondRungTests
//
//  Created by Emma O'Keeffe on 21/04/2019.
//  Copyright © 2019 O'Keeffe, Emma. All rights reserved.
//

import Foundation
import XCTest
@testable import SecondRung

class FoodStructTests: XCTestCase {
    let correctInitialization = FoodStruct(name: "Avocado", quantity : "100 grams", calcium : "12.0 mg", vitaminA : "43.8 ug", vitaminC : "10.0 mg", iron : "0.5 mg", potassium : "485 mg" )
    
    
    func testFoodStruct() {
        XCTAssertEqual(correctInitialization.name, "Avocado")
        XCTAssertEqual(correctInitialization.quantity, "100 grams")
        XCTAssertEqual(correctInitialization.calcium, "12.0 mg")
        XCTAssertEqual(correctInitialization.iron, "0.5 mg")
        XCTAssertEqual(correctInitialization.vitaminA, "43.8 ug")
        XCTAssertEqual(correctInitialization.vitaminC, "10.0 mg")
    }
    
}
