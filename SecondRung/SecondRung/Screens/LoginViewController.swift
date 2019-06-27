//
//  LoginViewController.swift
//  SecondRung
//
//  Created by Emma O'Keeffe on 23/01/2019.
//  Copyright © 2019 O'Keeffe, Emma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UINavigationControllerDelegate {

    let loginToList = "goHome"
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func login(_ sender: Any) {
        guard
            let emailtext = email.text,
            let passwordtext = password.text,
            emailtext.count > 0,
            passwordtext.count > 0
            else {
                presentAlert(title: "Invalid Credentials 😭", message: "Invalid Username or Password")
                return
        }
        
        Auth.auth().signIn(withEmail: emailtext, password: passwordtext) { user, error in
            if let error = error, user == nil {
                self.presentAlert(title: "Sign In Failed 😭", message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        self.performSegue(withIdentifier: "goToSignUp", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: self.loginToList, sender: nil)
                self.email.text = nil
                self.password.text = nil
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == email {
            password.becomeFirstResponder()
        }
        if textField == password {
            textField.resignFirstResponder()
        }
        return true
    }
}
