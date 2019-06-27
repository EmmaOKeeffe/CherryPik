//
//  SecondRungUITests.swift
//  SecondRungUITests
//
//  Created by Emma O'Keeffe on 05/04/2019.
//  Copyright © 2019 O'Keeffe, Emma. All rights reserved.
//

import XCTest

class SecondRungUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1InvalidLogin() {
        
        let app = XCUIApplication()
        app.textFields["Enter email address"].tap()
        
        app.secureTextFields["Enter password"].tap()
        
        app.buttons["Login Button"].tap()
        let alertBox = app.alerts["Invalid Credentials 😭"]
        XCTAssertTrue(alertBox.exists)
        alertBox.buttons["OK"].tap()
        
    }
    
    func test2InvalidSignUp() {
        
        let app = XCUIApplication()
        let signUpBtn = app.buttons["Sign Up Button"]
        signUpBtn.tap()
        
        let submitButton = app.navigationBars["Sign Up"].buttons["Submit"]
        submitButton.tap()
        let alertBox = app.alerts["Failed Sign Up 😭"]
        XCTAssertTrue(alertBox.exists)
        
        let okButton = app.alerts["Failed Sign Up 😭"].buttons["OK"]
        okButton.tap()
        
        let genderSegmentedControls = app.segmentedControls["Sign up - Gender"].buttons["Male"]
        genderSegmentedControls.tap()
        XCTAssertTrue(genderSegmentedControls.exists)
        submitButton.tap()
        
        XCTAssertTrue(alertBox.exists)
        okButton.tap()
        
        let signUpDateOfBirthDatePicker = app.datePickers["Sign up - Date of Birth"]
        signUpDateOfBirthDatePicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "January")
        signUpDateOfBirthDatePicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "1")
        signUpDateOfBirthDatePicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2006")
        XCTAssertTrue(signUpDateOfBirthDatePicker.exists)
        
        submitButton.tap()
        XCTAssertTrue(alertBox.exists)
        okButton.tap()
        
        signUpDateOfBirthDatePicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "January")
        signUpDateOfBirthDatePicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "1")
        signUpDateOfBirthDatePicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2000")
        
        submitButton.tap()
        XCTAssertTrue(alertBox.exists)
        okButton.tap()
        
        let emailTextField = app.textFields["Enter email address"]
        emailTextField.tap()
        emailTextField.typeText("testing2@test.test")
        XCTAssertTrue(emailTextField.exists)
        
        submitButton.tap()
        XCTAssertTrue(alertBox.exists)
        okButton.tap()
        
        let enterFirstNameTextField = app.textFields["Enter first name"]
        enterFirstNameTextField.tap()
        enterFirstNameTextField.typeText("Emma")
        XCTAssertTrue(enterFirstNameTextField.exists)
        
        submitButton.tap()
        XCTAssertTrue(alertBox.exists)
        okButton.tap()
        
        let enterLastNameTextField = app.textFields["Enter last name"]
        enterLastNameTextField.tap()
        enterLastNameTextField.typeText("O'Keeffe")
        
        submitButton.tap()
        XCTAssertTrue(alertBox.exists)
        okButton.tap()
        
        XCUIApplication().navigationBars["Sign Up"].buttons["Cancel"].tap()
        
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: signUpBtn, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func test3ValidSignUp() {
        
        let app = XCUIApplication()
        let signUpBtn = app.buttons["Sign Up Button"]
        signUpBtn.tap()

        let genderSegmentedControls = app/*@START_MENU_TOKEN@*/.segmentedControls["Sign up - Gender"].buttons["Female"]/*[[".segmentedControls[\"Sign up - Gender\"].buttons[\"Female\"]",".buttons[\"Female\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        genderSegmentedControls.tap()
        XCTAssertTrue(genderSegmentedControls.exists)

        let firstNameTextField = app.textFields["Enter first name"]
        firstNameTextField.tap()
        firstNameTextField.typeText("Emma")
        XCTAssertTrue(firstNameTextField.exists)

        let lastNameTextField = app.textFields["Enter last name"]
        lastNameTextField.tap()
        lastNameTextField.typeText("O'Keeffe")
        XCTAssertTrue(lastNameTextField.exists)

        let emailTextField = app.textFields["Enter email address"]
        emailTextField.tap()
        emailTextField.typeText("testing5@test.test")
        XCTAssertTrue(emailTextField.exists)

        let passwordTextField = app.secureTextFields["Enter Password"]
        passwordTextField.tap()
        passwordTextField.typeText("test123")
        XCTAssertTrue(passwordTextField.exists)

        let signUpDateOfBirthDatePicker = app.datePickers["Sign up - Date of Birth"]
        signUpDateOfBirthDatePicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "January")
        signUpDateOfBirthDatePicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "1")
        signUpDateOfBirthDatePicker.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2001")
        XCTAssertTrue(signUpDateOfBirthDatePicker.exists)

        app.navigationBars["Sign Up"].buttons["Submit"].tap()
        
        let calanderbtn = app.buttons["Calander Button"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: calanderbtn, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

    }
    
    func test4ValidSignOut() {
        let app = XCUIApplication()
        let calanderbtn = app.buttons["Calander Button"]
        
        XCTAssertTrue(calanderbtn.exists)
        app.navigationBars["Home"].buttons["Sign Out"].tap()
        let signUpBtn = app.buttons["Sign Up Button"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: signUpBtn, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test5ValidLogin() {
        
        let app = XCUIApplication()
        let usernameTextField = app.textFields["Enter email address"]
        usernameTextField.tap()
        usernameTextField.typeText("test15@test.test")
        XCTAssertTrue(usernameTextField.exists)
        
        let passwordTextField = app.secureTextFields["Enter password"]
        passwordTextField.tap()
        //passwordTextField.typeText("")
        XCTAssertTrue(passwordTextField.exists)
        
        app.buttons["Login Button"].tap()
        let calanderbtn = app.buttons["Calander Button"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: calanderbtn, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test6PastDatesTableView() {
        
        let app = XCUIApplication()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let todaysDate = formatter.string(from: date)
        
        let calanderbtn = app.buttons["Calander Button"]
        calanderbtn.tap()
        
        let pastDatesTodaysDate = app.tables.cells.staticTexts[todaysDate]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: pastDatesTodaysDate, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        pastDatesTodaysDate.tap()

        let backToPastDatesBtn = app.buttons["Back to Dates Button"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backToPastDatesBtn, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        backToPastDatesBtn.tap()

        let backToDashboardBtn =  app.navigationBars["SecondRung.PastDatesTableView"].buttons["Home"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: backToDashboardBtn, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        backToDashboardBtn.tap()

        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: calanderbtn, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test7TabViews() {
        
        let app = XCUIApplication()
        
        let goToAddTabViewBtn = app.navigationBars["Home"].buttons["Add"]
        XCTAssertTrue(goToAddTabViewBtn.exists)
        goToAddTabViewBtn.tap()
        
        let tabBarsQuery = app.tabBars
        
        let searchTabViewBtn = tabBarsQuery.buttons["Search"]
        XCTAssertTrue(searchTabViewBtn.exists)
        
        let searchField = app.searchFields["Enter Fruit/Vegetable Name"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: searchField, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        searchField.tap()
        searchField.typeText("A")
        
        let tablesQuery = app.tables
        
        let apricotCell = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Apricot"]/*[[".cells.staticTexts[\"Apricot\"]",".staticTexts[\"Apricot\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: apricotCell, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        apricotCell.tap()
        
        let addToProfileBtn = app.buttons["Add Item to Profile Button"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: addToProfileBtn, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        addToProfileBtn.tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Asparagus"]/*[[".cells.staticTexts[\"Asparagus\"]",".staticTexts[\"Asparagus\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let cancelAddBtn = app.buttons["Cancel Button"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: cancelAddBtn, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        cancelAddBtn.tap()
        
        let cameraTabViewBtn = tabBarsQuery.buttons["Camera"]
        XCTAssertTrue(cameraTabViewBtn.exists)
        
        cameraTabViewBtn.tap()
        
        let accessCameraBtn = app.buttons["Camera Button"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: accessCameraBtn, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        let fitbitTabViewBtn = tabBarsQuery.buttons["FitBit Sync"]
        XCTAssertTrue(fitbitTabViewBtn.exists)
        fitbitTabViewBtn.tap()
        
        let fitbitSyncBtn = app.buttons["Firbit Sync Button"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: fitbitSyncBtn, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        let goToDashboardBtn = app.navigationBars["UITabBar"].buttons["Home"]
        XCTAssertTrue(goToDashboardBtn.exists)
        goToDashboardBtn.tap()
    }
    

}
