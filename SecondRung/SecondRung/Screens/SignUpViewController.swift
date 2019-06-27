//
//  SignUpViewController.swift
//  SecondRung
//
//  Created by Emma O'Keeffe on 26/01/2019.
//  Copyright © 2019 O'Keeffe, Emma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var genderField: UISegmentedControl!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    var dateOfBirth: String!
    
    var gender: String!
    
    let dateFormatter = DateFormatter()
    
    var datePickerChanged = false
    
    var genderSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datePicker.backgroundColor = .white
        self.genderField.accessibilityLabel = "Sign up - Gender"
        self.datePicker.accessibilityLabel = "Sign up - Date of Birth"

        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "goToHome", sender: nil)
                self.emailField.text = nil
                self.passwordField.text = nil
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        self.datePickerChanged = true
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        self.dateOfBirth = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func genderFieldChanged(_ sender: Any) {
        self.genderSelected = true
        switch genderField.selectedSegmentIndex
        {
        case 0:
            self.gender = "f"
        case 1:
            self.gender = "m"
        default:
            self.gender = ""
        }
    }
    
    func runChecks() -> Bool {
        
        if (self.datePickerChanged == false) {
            presentAlert(title: "Failed Sign Up 😭", message: "Must enter Date of Birth.")
            return false
        } else if (self.genderSelected == false) {
            presentAlert(title: "Failed Sign Up 😭", message: "Must select Gender.")
            return false
        }
        
        let age = getAge(dob: self.dateOfBirth)
        
        if !isOverEighteen(age: age) {
            presentAlert(title: "Failed Sign Up 😭", message: "Must be age 18 or older.")
            return false
        } else if !isValidGender(gender: self.gender) {
            presentAlert(title: "Failed Sign Up 😭", message: "Gender required for Sign Up.")
            return false
        } else if !isValidEmail(email: self.emailField.text ?? "") {
            presentAlert(title: "Failed Sign Up 😭", message: "Email required for Sign Up.\nMust contain an @ and a ., be atleast 6 characters and no more than 35 characters.")
            return false
        } else if !isValidName(name: self.firstName.text ?? "") {
            presentAlert(title: "Failed Sign Up 😭", message: "First name required for Sign Up.\nNo more than 15 characters long.")
            return false
        } else if !isValidName(name: self.lastName.text ?? "") {
            presentAlert(title: "Failed Sign Up 😭", message: "Last name required for Sign Up.\nNo more than 15 characters long.")
            return false
        } else if !isValidPassword(password: self.passwordField.text ?? "") {
            presentAlert(title: "Failed Sign Up 😭", message: "Password required for Sign Up.\nMust be 6 characters or longer.")
            return false
        } else {
            return true
        }
    }
    
    @IBAction func didTapSubmit(_ sender: Any) {
        if runChecks() {
            Auth.auth().createUser(withEmail: self.emailField.text!, password: self.passwordField.text!) { user, error in
                if error == nil {
                    self.saveProfileToDatabase() { success in
                        if success {
                            Auth.auth().signIn(withEmail: self.emailField.text!, password: self.passwordField.text!) { user, error in
                                if let error = error, user == nil {
                                    let alert = UIAlertController(title: "Sign Up Failed",
                                                                  message: error.localizedDescription,
                                                                  preferredStyle: .alert)
                                    
                                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            }
        } else {
            print("Failed sign up due to credentials")
        }
        
    }
    
    func saveProfileToDatabase(completion: @escaping ((_ success:Bool)->())) {
        guard let uuid = Auth.auth().currentUser?.uid else { return }
        
        let age = getAge(dob: self.dateOfBirth)
        
        var user = User(uuid: uuid, firstName: self.firstName.text!, lastName: self.lastName.text!, gender: self.gender, dateOfBirth: self.dateOfBirth, age: age)
        user.setRDA()
        
        print(user)
        
        let ref = Database.database().reference().child("user/profile/\(uuid)")
        
        let userObject = ["firstName" : user.firstName,
                          "lastName" : user.lastName,
                          "dob" : user.dateOfBirth,
                          "gender" : user.gender,
                          "vitARDA" : user.vitARDA,
                          "vitCRDA" : user.vitCRDA,
                          "ironRDA" : user.ironRDA,
                          "potassRDA" : user.potassRDA,
                          "calciumRDA" : user.calciumRDA ] as [String: Any]
        
        ref.setValue(userObject) { error, dbref in
            completion(error == nil)
        }
    }
    
    func isOverEighteen(age: Int) -> Bool {
        if age < 18 {
            return false
        } else {
            return true
        }
    }
    
    func isValidGender(gender: String) -> Bool {
        if gender == "f" || gender == "m" {
            return true
        } else {
            return false
        }
    }
    
    func isValidName(name: String) -> Bool {
        if name == "" {
            return false
        } else if name.count > 15 {
            return false
        } else {
            return true
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        if email == "" {
            return false
        } else if email.count > 35  || email.count < 6 {
            return false
        } else if email.contains("@") == false || email.contains(".") == false {
            return false
        } else {
            return true
        }
    }
    
    func isValidPassword(password: String) -> Bool {
        if password == "" || password.count < 6 {
            return false
        } else {
            return true
        }
    }

    func getAge(dob: String) -> Int {
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let now = Date()
        
        let birthdayDate = dateFormatter.date(from: dob)
        print(birthdayDate ?? "")
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: birthdayDate!, to: now)
        let age = ageComponents.year!
        
        return age
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
