//
//  DatePopOverViewController.swift
//  SecondRung
//
//  Created by Emma O'Keeffe on 22/03/2019.
//  Copyright © 2019 O'Keeffe, Emma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class DatePopOverViewController: UIViewController {
    
    var dateName : String!
    
    let ref = Database.database().reference()

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var ironProgressBar: UIProgressView!
    
    @IBOutlet weak var vitaminCProgressBar: UIProgressView!
    
    @IBOutlet weak var vitaminAProgressBar: UIProgressView!
    
    @IBOutlet weak var potassiumProgressBar: UIProgressView!
    
    @IBOutlet weak var calciumProgressBar: UIProgressView!
    
    @IBOutlet weak var ironRDALabel: UILabel!
    
    @IBOutlet weak var dateText: UILabel!
    
    @IBOutlet weak var vitCRDALabel: UILabel!
    
    @IBOutlet weak var vitARDALabel: UILabel!
    
    @IBOutlet weak var potasRDALabel: UILabel!
    
    @IBOutlet weak var calRDALabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateText.text = dateName
        self.accessUserDatabaseInfo()
    }

    @IBAction func didTapBackBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func accessUserDatabaseInfo() {
        guard let uuid = Auth.auth().currentUser?.uid else { return }
        
        
        ref.child("user").child("profile").child(uuid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(self.dateName) {
                if let userData = snapshot.value as? [String:Any] {
                    let calciumRDA = userData["calciumRDA"] as? Int
                    let ironRDA = userData["ironRDA"] as? Int
                    let potassRDA = userData["potassRDA"] as? Int
                    let vitARDA = userData["vitARDA"] as? Int
                    let vitCRDA = userData["vitCRDA"] as? Int
                    
                    self.ref.child("user").child("profile").child(uuid).child(self.dateName).observeSingleEvent(of: .value) { (snapshot) in
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
                            
                            self.ironProgressBar.setProgress(progress.ironProgress, animated: true)
                            self.calciumProgressBar.setProgress(progress.calciumProgress, animated: true)
                            self.potassiumProgressBar.setProgress(progress.potassProgress, animated: true)
                            self.vitaminAProgressBar.setProgress(progress.vitAProgress, animated: true)
                            self.vitaminCProgressBar.setProgress(progress.vitCProgress, animated: true)
                            
                        }
                    }
                }
            } else {
                print("Date doesn't exist")
            }
        })
    }
    
    func extractNutrionalFloat(nutritionalString: String) -> Float {
        let nutritionStringArray : [String] = nutritionalString.components(separatedBy: " ")
        let nutritionFloat : Float? = Float(nutritionStringArray[0])
        
        return nutritionFloat ?? 0.00
    }
    
    func calcRDA(userCalciumFloat: Float, userIronFloat: Float, userPotassiumFloat: Float, userVitaminAFloat: Float, userVitaminCFloat: Float, calciumRDA: Int, ironRDA: Int, potassRDA: Int, vitARDA: Int, vitCRDA: Int) -> (ironProgress: Float, calciumProgress: Float, potassProgress: Float, vitAProgress: Float, vitCProgress: Float) {
        
        let ironProgress : Float = userIronFloat/Float(ironRDA)
        let calciumProgress : Float = userCalciumFloat/Float(calciumRDA)
        let potassProgress : Float = userPotassiumFloat/Float(potassRDA)
        let vitAProgress : Float = userVitaminAFloat/Float(vitARDA)
        let vitCProgress : Float = userVitaminCFloat/Float(vitCRDA)
        
        return (ironProgress, calciumProgress, potassProgress, vitAProgress, vitCProgress)
        
    }
}
