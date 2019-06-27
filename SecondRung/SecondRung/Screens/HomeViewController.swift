//
//  HomeViewController.swift
//  SecondRung
//
//  Created by Emma O'Keeffe on 25/01/2019.
//  Copyright © 2019 O'Keeffe, Emma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var ironProgressView: UIProgressView!
    
    @IBOutlet weak var vitaminCProgressView: UIProgressView!
    
    @IBOutlet weak var vitaminAProgressView: UIProgressView!
    
    @IBOutlet weak var potassiumProgressView: UIProgressView!
    
    @IBOutlet weak var calciumProgressView: UIProgressView!
    
    @IBOutlet weak var ironRDALabel: UILabel!
    
    @IBOutlet weak var vitCRDALabel: UILabel!
    
    @IBOutlet weak var vitARDALabel: UILabel!
    
    @IBOutlet weak var potasRDALabel: UILabel!
    
    @IBOutlet weak var calRDALabel: UILabel!
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.accessUserDatabaseInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.accessUserDatabaseInfo()
    }
    
    @IBAction func didTapSignOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
    }
    
    @IBAction func didTapAddButton(_ sender: Any) {
        self.performSegue(withIdentifier: "addItem", sender: nil)
    }
    
    @IBAction func didTapCalanderBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "goToPastDates", sender: nil)
    }
    
    func accessUserDatabaseInfo() {
        guard let uuid = Auth.auth().currentUser?.uid else { return }
        
        let todaysDate = getTodaysDate()
        
        ref.child("user").child("profile").child(uuid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(todaysDate) {
                
                if let userData = snapshot.value as? [String:Any] {
                    let calciumRDA = userData["calciumRDA"] as? Int
                    let ironRDA = userData["ironRDA"] as? Int
                    let potassRDA = userData["potassRDA"] as? Int
                    let vitARDA = userData["vitARDA"] as? Int
                    let vitCRDA = userData["vitCRDA"] as? Int
                self.ref.child("user").child("profile").child(uuid).child(todaysDate).observeSingleEvent(of: .value) { (snapshot) in
                        if let data = snapshot.value as? [String:Any] {
                            
                            let userCalciumFloat = self.extractNutrionalFloat(nutritionalString: (data["calciumIntake"] as? String) ?? "0.0 mg")
                            let userIronFloat = self.extractNutrionalFloat(nutritionalString: (data["ironIntake"] as? String) ?? "0.0 mg")
                            let userPotassiumFloat = self.extractNutrionalFloat(nutritionalString: (data["potassiumIntake"] as? String) ?? "0.0 mg")
                            let userVitaminAFloat = self.extractNutrionalFloat(nutritionalString: (data["vitaminAIntake"] as? String) ?? "0.0 ug")
                            let userVitaminCFloat = self.extractNutrionalFloat(nutritionalString: (data["vitaminCIntake"] as? String) ?? "0.0 mg")
                            
                            let progress = self.calcRDA(userCalciumFloat: userCalciumFloat, userIronFloat: userIronFloat, userPotassiumFloat: userPotassiumFloat, userVitaminAFloat: userVitaminAFloat, userVitaminCFloat: userVitaminCFloat, calciumRDA: calciumRDA!, ironRDA: ironRDA!, potassRDA: potassRDA!, vitARDA: vitARDA!, vitCRDA: vitCRDA!)
                            
                            self.ironRDALabel.text = String(format: "%.1f/%d", userIronFloat, ironRDA ?? 0.0)
                            self.calRDALabel.text = String(format: "%.1f/%d", userCalciumFloat, calciumRDA ?? 0.0)
                            self.potasRDALabel.text = String(format: "%.1f/%d", userPotassiumFloat, potassRDA ?? 0.0)
                            self.vitARDALabel.text = String(format: "%.1f/%d", userVitaminAFloat, vitARDA ?? 0.0)
                            self.vitCRDALabel.text = String(format: "%.1f/%d", userVitaminCFloat, vitCRDA ?? 0.0)
                            
                            self.ironProgressView.setProgress(progress.ironProgress, animated: true)
                            self.calciumProgressView.setProgress(progress.calciumProgress, animated: true)
                            self.potassiumProgressView.setProgress(progress.potassProgress, animated: true)
                            self.vitaminAProgressView.setProgress(progress.vitAProgress, animated: true)
                            self.vitaminCProgressView.setProgress(progress.vitCProgress, animated: true)
                            
                        }
                    }
                }
            } else {
                let newRef = Database.database().reference().child("user/profile/\(uuid)/\(todaysDate)")
                
                let consumedObject = ["calciumIntake" : "0 mg",
                                      "ironIntake" : "0 mg",
                                      "vitaminAIntake" : "0 ug",
                                      "vitaminCIntake" : "0 mg",
                                      "potassiumIntake": "0 mg",
                                      "fitBitFoods": ""]
                
                newRef.setValue(consumedObject)
            }
        })
    }
    
    func getTodaysDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let todaysDate = formatter.string(from: date)
        
        return todaysDate
    }

    func calcRDA(userCalciumFloat: Float, userIronFloat: Float, userPotassiumFloat: Float, userVitaminAFloat: Float, userVitaminCFloat: Float, calciumRDA: Int, ironRDA: Int, potassRDA: Int, vitARDA: Int, vitCRDA: Int) -> (ironProgress: Float, calciumProgress: Float, potassProgress: Float, vitAProgress: Float, vitCProgress: Float) {
        
        let ironProgress : Float = userIronFloat/Float(ironRDA)
        let calciumProgress : Float = userCalciumFloat/Float(calciumRDA)
        let potassProgress : Float = userPotassiumFloat/Float(potassRDA)
        let vitAProgress : Float = userVitaminAFloat/Float(vitARDA)
        let vitCProgress : Float = userVitaminCFloat/Float(vitCRDA)
        
        return (ironProgress, calciumProgress, potassProgress, vitAProgress, vitCProgress)
    }
    
    func extractNutrionalFloat(nutritionalString: String) -> Float {
        let nutritionStringArray : [String] = nutritionalString.components(separatedBy: " ")
        let nutritionFloat : Float? = Float(nutritionStringArray[0])
        
        return nutritionFloat ?? 0.00
    }
}
