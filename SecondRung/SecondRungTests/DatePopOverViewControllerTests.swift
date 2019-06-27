//
//  DatePopOverViewControllerTests.swift
//  SecondRungTests
//
//  Created by Emma O'Keeffe on 05/04/2019.
//  Copyright © 2019 O'Keeffe, Emma. All rights reserved.
//

import Foundation
import XCTest
@testable import SecondRung

class DatePopOverViewControllerTests: XCTestCase {
    
    let viewController = DatePopOverViewController()
    
    func testCalcRDA() {
        //RDA values based on female over of age 26
        let calciumRDA = 950
        let ironRDA = 16
        let potassRDA = 3500
        let vitARDA = 650
        let vitCRDA = 95
        
        //Based on Grapefruit compositional values
        let userCalciumFloat = 22.0
        let userIronFloat = 0.1
        let userPotassiumFloat = 135
        let userVitaminAFloat = 345.0
        let userVitaminCFloat = 31.2
        
        let calculations = viewController.calcRDA(userCalciumFloat: Float(userCalciumFloat), userIronFloat: Float(userIronFloat), userPotassiumFloat: Float(userPotassiumFloat), userVitaminAFloat: Float(userVitaminAFloat), userVitaminCFloat: Float(userVitaminCFloat), calciumRDA: calciumRDA, ironRDA: ironRDA, potassRDA: potassRDA, vitARDA: vitARDA, vitCRDA: vitCRDA)
        
        XCTAssertEqual(calculations.calciumProgress, 0.023157895)
        XCTAssertEqual(calculations.ironProgress, 0.00625)
        XCTAssertEqual(calculations.potassProgress, 0.038571429)
        XCTAssertEqual(calculations.vitAProgress, 0.53076923)
        XCTAssertEqual(calculations.vitCProgress, 0.32842105)
        
        XCTAssertNotEqual(calculations.calciumProgress, 0)
        XCTAssertNotEqual(calculations.ironProgress, 1)
        XCTAssertNotEqual(calculations.potassProgress, 0.03852542657245)
        XCTAssertNotEqual(calculations.vitAProgress, 37.0000000000000)
        XCTAssertNotEqual(calculations.vitCProgress, 0.32000000)
    }
    
    func testExtractNutrionalFloat() {
        let idealCase = "10.04 ug"
        let idealCaseResult = viewController.extractNutrionalFloat(nutritionalString: idealCase)
        XCTAssertEqual(idealCaseResult, 10.04)
        
        let notIdealCase = "0"
        let notIdealCaseResult = viewController.extractNutrionalFloat(nutritionalString: notIdealCase)
        XCTAssertEqual(notIdealCaseResult, 0.0)
    }
    
}
