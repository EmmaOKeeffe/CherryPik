//
//  FoodPopOverViewController.swift
//  SecondRung
//
//  Created by Emma O'Keeffe on 05/02/2019.
//  Copyright © 2019 O'Keeffe, Emma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class FoodPopOverViewController: UIViewController {
    
    var foodName : String!
    
    var nutrionalItems : Dictionary = [String : NutritionalInfo]()
    
    var nutritionalInfo = [NutritionalInfo]()
    
    let ref = Database.database().reference()

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var foodLabel: UILabel!
    
    @IBOutlet weak var addItem: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.foodLabel.text = foodName.capitalized
        
        getFoodInfoFromDatabase(foodName: foodName.capitalized)
        
        configureTableView()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self

    }
    
    func getFoodInfoFromDatabase(foodName: String) {
        ref.child("Produce").child(foodName).observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? [String:Any] {
                
                let quantity = NutritionalInfo(title: "Quantity", amount: (data["Quantity"] as? String)!)
                self.nutritionalInfo.append(quantity)
                self.nutrionalItems["quantity"] = quantity
                
                let calcium = NutritionalInfo(title: "Calcium", amount: (data["Calcium"] as? String)!)
                self.nutritionalInfo.append(calcium)
                self.nutrionalItems["calcium"] = calcium
                
                let iron = NutritionalInfo(title: "Iron", amount: (data["Iron"] as? String)!)
                self.nutritionalInfo.append(iron)
                self.nutrionalItems["iron"] = iron
                
                let potassium = NutritionalInfo(title: "Potassium", amount: (data["Potassium"] as? String)!)
                self.nutritionalInfo.append(potassium)
                self.nutrionalItems["potassium"] = potassium
                
                let vitaminA = NutritionalInfo(title: "Vitamin A", amount: (data["VitaminA"] as? String)!)
                self.nutritionalInfo.append(vitaminA)
                self.nutrionalItems["vitaminA"] = vitaminA
                
                let vitaminC = NutritionalInfo(title: "Vitamin C", amount: (data["VitaminC"] as? String)!)
                self.nutritionalInfo.append(vitaminC)
                self.nutrionalItems["vitaminC"] = vitaminC

                self.tableView.reloadData()
                
            }
        }
    }

    @IBAction func didTapAddItem(_ sender: Any) {
        self.addFoodItemToUserProfile() { success in
            if success {
                print("Profile Updated")
            }
        }
        dismiss(animated: true)
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    func getTodaysDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let todaysDate = formatter.string(from: date)
        
        return todaysDate
    }
    
    func addFoodItemToUserProfile(completion: @escaping ((_ success:Bool)->())) {
        guard let uuid = Auth.auth().currentUser?.uid else { return }

        let todaysDate = getTodaysDate()
        
        ref.child("user").child("profile").child(uuid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(todaysDate){
                
                self.updateUserProfile(date: todaysDate, uuid: uuid) { success in
                    if success {
                        print("Profile Saved")
                    }
                }

            } 
        })
    }
    
    func extractNutrionalFloat(nutritionalString: String) -> Float {
        let nutritionStringArray : [String] = nutritionalString.components(separatedBy: " ")
        let nutritionFloat : Float? = Float(nutritionStringArray[0])
        
        return nutritionFloat ?? 0.00
    }
    
    func updateUserProfile(date: String, uuid: String, completion: @escaping ((_ success:Bool)->()) ) {
        ref.child("user").child("profile").child(uuid).child(date).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String:Any] {
                
                let userCalciumFloat = self.extractNutrionalFloat(nutritionalString: (data["calciumIntake"] as? String)!)
                let userIronFloat = self.extractNutrionalFloat(nutritionalString: (data["ironIntake"] as? String)!)
                let userPotassiumFloat = self.extractNutrionalFloat(nutritionalString: (data["potassiumIntake"] as? String)!)
                let userVitaminAFloat = self.extractNutrionalFloat(nutritionalString: (data["vitaminAIntake"] as? String)!)
                let userVitaminCFloat = self.extractNutrionalFloat(nutritionalString: (data["vitaminCIntake"] as? String)!)
                
                let itemCalciumFloat = self.extractNutrionalFloat(nutritionalString: self.nutrionalItems["calcium"]!.amount)
                let itemIronFloat = self.extractNutrionalFloat(nutritionalString: self.nutrionalItems["iron"]!.amount)
                let itemPotassiumFloat = self.extractNutrionalFloat(nutritionalString: self.nutrionalItems["potassium"]!.amount)
                let itemVitaminAFloat = self.extractNutrionalFloat(nutritionalString: self.nutrionalItems["vitaminA"]!.amount)
                let itemVitaminCFloat = self.extractNutrionalFloat(nutritionalString: self.nutrionalItems["vitaminC"]!.amount)

                let newCalciumFloat : Float = userCalciumFloat + itemCalciumFloat
                let newIronFloat : Float = userIronFloat + itemIronFloat
                let newPotassiumFloat : Float = userPotassiumFloat + itemPotassiumFloat
                let newVitaminAFloat : Float = userVitaminAFloat + itemVitaminAFloat
                let newVitaminCFloat : Float = userVitaminCFloat + itemVitaminCFloat
                
                let newRef = self.ref.child("user/profile/\(uuid)/\(date)")
                
                let consumedObject = ["calciumIntake" : String(format: "%.1f mg", newCalciumFloat),
                                      "ironIntake" : String(format: "%.1f mg", newIronFloat),
                                      "vitaminAIntake" : String(format: "%.1f ug", newVitaminAFloat),
                                      "vitaminCIntake" : String(format: "%.1f mg", newVitaminCFloat),
                                      "potassiumIntake": String(format: "%.1f mg", newPotassiumFloat)]
                
                newRef.updateChildValues(consumedObject) { error, dbref in
                    completion(error == nil)
                }
            }
        })
    }
}

extension FoodPopOverViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutritionalInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!

        let nutritionalInfoElement = nutritionalInfo[indexPath.row]
        cell.textLabel?.text = "\(nutritionalInfoElement.title) = \(nutritionalInfoElement.amount)"
        cell.textLabel?.textColor = UIColor.darkGray
        
        return cell
        
    }
}
