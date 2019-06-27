//
//  PastDatesTests.swift
//  SecondRungTests
//
//  Created by Emma O'Keeffe on 27/03/2019.
//  Copyright © 2019 O'Keeffe, Emma. All rights reserved.
//
import Foundation
import XCTest
@testable import SecondRung

class PastDatesTableViewControllerTests : XCTestCase {
    let viewController = PastDatesTableViewController()
    
    func testValidDate() {
        XCTAssertTrue(viewController.isDate(date: "27-03-2019"))
        XCTAssertFalse(viewController.isDate(date: "calciumRDA"))
        XCTAssertFalse(viewController.isDate(date: "2019-03-31"))
    }
}
