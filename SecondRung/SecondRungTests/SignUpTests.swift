//
//  SignUpTests.swift
//  SecondRungTests
//
//  Created by Emma O'Keeffe on 13/03/2019.
//  Copyright © 2019 O'Keeffe, Emma. All rights reserved.
//

import Foundation
import XCTest
@testable import SecondRung

class SignUpViewControllerTests : XCTestCase {
    
    let viewController = SignUpViewController()
    
    func testValidAge() {
        XCTAssertTrue(viewController.isOverEighteen(age: 18))
        XCTAssertFalse(viewController.isOverEighteen(age: 10))
    }
    
    func testValidGender() {
        XCTAssertTrue(viewController.isValidGender(gender: "f"))
        XCTAssertTrue(viewController.isValidGender(gender: "m"))
        XCTAssertFalse(viewController.isValidGender(gender: ""))
        XCTAssertFalse(viewController.isValidGender(gender: "kdknsv"))
        XCTAssertFalse(viewController.isValidGender(gender: "1"))
    }
    
    func testValidEmail() {
        XCTAssertTrue(viewController.isValidEmail(email: "e@e.ie"))
        XCTAssertTrue(viewController.isValidEmail(email: "e1@e.com"))
        XCTAssertFalse(viewController.isValidEmail(email: "eee.ie"))
        XCTAssertFalse(viewController.isValidEmail(email: "eeie"))
        XCTAssertFalse(viewController.isValidEmail(email: "eeieguy@jj"))
        XCTAssertFalse(viewController.isValidEmail(email: "eeejvfdvsivsd@kvnsdknvsodnvsjkdfn.com"))
        XCTAssertFalse(viewController.isValidEmail(email: "e@e.e"))
        XCTAssertFalse(viewController.isValidEmail(email: ""))
    }
    
    func testValidName() {
        XCTAssertTrue(viewController.isValidName(name: "Emma"))
        XCTAssertTrue(viewController.isValidName(name: "C3P0"))
        XCTAssertFalse(viewController.isValidName(name: ""))
        XCTAssertFalse(viewController.isValidName(name: "jdfbvajdfbvljabdfljvbaldfjbvlajb"))
    }
    
    func testValidPassword() {
        XCTAssertTrue(viewController.isValidPassword(password: "password"))
        XCTAssertTrue(viewController.isValidPassword(password: "password123"))
        XCTAssertTrue(viewController.isValidPassword(password: "jdbvaljfbdvabfdvbalfdbvlaffjh42345';bajfkdbakfbd"))
        XCTAssertTrue(viewController.isValidPassword(password: "passwo"))
        XCTAssertFalse(viewController.isValidPassword(password: "passw"))
        XCTAssertFalse(viewController.isValidPassword(password: ""))
    }
    
    func testGetAge() {
        let age = viewController.getAge(dob: "14/3/1994")
        
        XCTAssertEqual(age, 25)
        XCTAssertNotEqual(age, 0)
        XCTAssertNotEqual(age, 100)
        XCTAssertNotEqual(age, 26)
        XCTAssertNotEqual(age, -25)
    }
}
