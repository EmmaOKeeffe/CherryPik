//
//  UserTests.swift
//  SecondRungTests
//
//  Created by Emma O'Keeffe on 21/04/2019.
//  Copyright © 2019 O'Keeffe, Emma. All rights reserved.
//
import Foundation
import XCTest
@testable import SecondRung

class UserTests: XCTestCase {
    
    var user1 = User(uuid: "userid", firstName: "Emma", lastName: "O'Keeffe", gender: "f", dateOfBirth: "14/03/1994", age: 25)
    
    var user2 = User(uuid: "userid", firstName: "Emma", lastName: "O'Keeffe", gender: "m", dateOfBirth: "14/03/1994", age: 25)
    
    var user3 = User(uuid: "userid", firstName: "Emma", lastName: "O'Keeffe", gender: "f", dateOfBirth: "14/03/1993", age: 24)
    
    var user4 = User(uuid: "userid", firstName: "Emma", lastName: "O'Keeffe", gender: "f", dateOfBirth: "14/03/1964", age: 55)
    
    func testUser1Details() {
        
        XCTAssertEqual(user1.calciumRDA, 0)
        XCTAssertEqual(user1.potassRDA, 3500)
        XCTAssertEqual(user1.ironRDA, 0)
        XCTAssertEqual(user1.vitARDA, 0)
        XCTAssertEqual(user1.vitCRDA, 0)
        
        user1.setRDA()
        
        XCTAssertEqual(user1.calciumRDA, 950)
        XCTAssertEqual(user1.potassRDA, 3500)
        XCTAssertEqual(user1.ironRDA, 16)
        XCTAssertEqual(user1.vitARDA, 650)
        XCTAssertEqual(user1.vitCRDA, 95)
    }
    
    func testUser2Details() {
        
        user2.setRDA()
        
        XCTAssertEqual(user2.calciumRDA, 950)
        XCTAssertEqual(user2.potassRDA, 3500)
        XCTAssertEqual(user2.ironRDA, 11)
        XCTAssertEqual(user2.vitARDA, 750)
        XCTAssertEqual(user2.vitCRDA, 110)
    }
    
    func testUser3Details() {
        
        user3.setRDA()
        
        XCTAssertEqual(user3.calciumRDA, 1000)
        XCTAssertEqual(user3.potassRDA, 3500)
        XCTAssertEqual(user3.ironRDA, 16)
        XCTAssertEqual(user3.vitARDA, 650)
        XCTAssertEqual(user3.vitCRDA, 95)
    }
    
    func testUser4Details() {
        
        user4.setRDA()
        
        XCTAssertEqual(user4.calciumRDA, 950)
        XCTAssertEqual(user4.potassRDA, 3500)
        XCTAssertEqual(user4.ironRDA, 11)
        XCTAssertEqual(user4.vitARDA, 650)
        XCTAssertEqual(user4.vitCRDA, 95)
    }
    
}

