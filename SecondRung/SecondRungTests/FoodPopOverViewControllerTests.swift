//
//  FoodPopOverViewControllerTests.swift
//  SecondRungTests
//
//  Created by Emma O'Keeffe on 09/04/2019.
//  Copyright © 2019 O'Keeffe, Emma. All rights reserved.
//


import Foundation
import XCTest
@testable import SecondRung

class FoodPopOverViewControllerTests: XCTestCase {
    
    let viewController = FoodPopOverViewController()
        
    func testGetTodaysDate() {
        let testDate = viewController.getTodaysDate()
        XCTAssertNotEqual(testDate, "this_is_not_a_date")
        XCTAssertNotEqual(testDate, "1")
        XCTAssertNotEqual(testDate, "09/04/19")
        XCTAssertNotEqual(testDate, "2019-4-9")
    }
    
    func testExtractNutrionalFloat() {
        let idealCase = "1.0 mg"
        let idealCaseResult = viewController.extractNutrionalFloat(nutritionalString: idealCase)
        XCTAssertEqual(idealCaseResult, 1.0)
        
        let notIdealCase = "jibberish"
        let notIdealCaseResult = viewController.extractNutrionalFloat(nutritionalString: notIdealCase)
        XCTAssertEqual(notIdealCaseResult, 0.0)
    }
    
}
