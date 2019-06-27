//
//  FitBitSyncViewController.swift
//  SecondRung
//
//  Created by Emma O'Keeffe on 24/03/2019.
//  Copyright © 2019 O'Keeffe, Emma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import OAuthSwift

class FitBitSyncViewController: UIViewController {
    
    let ref = Database.database().reference()
    
    var oauthswift: OAuthSwift?
    
    let date = Date()
    let formatter = DateFormatter()
    
    var foodsInDB = [String]()
    
    var multiFoodItems = [FoodStruct]()
    
    var fitbitFoods = [String]()
    
    var allFitBitFoods = [String]()
    
    var calFloat : Float = 0
    var irnFloat : Float = 0
    var vitAFloat : Float = 0
    var vitCFloat : Float = 0
    var potFloat : Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadingView.hidesWhenStopped = true
    }
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    @IBAction func didTapFitBitSyncBtn(_ sender: Any) {
        
        let isReset = resetVariables()
        
        if isReset {
            self.getFoodsInDB()
            self.doOAuthFitbit2()
        }
    }
    
    func resetVariables() -> Bool {
        self.multiFoodItems.removeAll()
        self.fitbitFoods.removeAll()
        self.allFitBitFoods.removeAll()
        
        self.calFloat = 0
        self.irnFloat = 0
        self.vitAFloat = 0
        self.vitCFloat = 0
        self.potFloat = 0
        
        return true
    }
    
    func getFoodsInDB() {
        ref.child("Produce").observeSingleEvent(of: .value, with: { (snapshot) in
            if let foodData = snapshot.value as? [String:Any] {
                for data in foodData.keys {
                    self.foodsInDB.append(data)
                }
            }
        })
    }
    
    func addItemsToDB() {
        print(self.multiFoodItems)
        
        if self.multiFoodItems.isEmpty == false {
            
            self.addToDatabase() { success in
                if success {
                    print("Profile Updated")
                }
            }
        } else {
            self.loadingView.stopAnimating()
        }
    }
    
    func getTodaysDate() -> String {
        formatter.dateFormat = "dd-MM-yyyy"
        let todaysDate = formatter.string(from: date)
        return todaysDate
    }
    
    func doOAuthFitbit2() {
        let oauthswift = OAuth2Swift(
            consumerKey:    tokens["consumerKey"] ?? "",
            consumerSecret: tokens["consumerSecret"] ?? "",
            authorizeUrl:   tokens["authorizeUrl"] ?? "",
            accessTokenUrl: tokens["accessTokenUrl"] ?? "",
            responseType:   "token"
        )
        
        oauthswift.accessTokenBasicAuthentification = true
        
        self.oauthswift = oauthswift
        oauthswift.authorizeURLHandler = getURLHandler()
        let state = generateState(withLength: 20)
        
        let _ = oauthswift.authorize(
            withCallbackURL: URL(string: "CherryPik://oauth-callback/fitbit2")!, scope: "nutrition", state: state,
            success: { credential, response, parameters in
                self.getFitBitFoodLog(oauthswift)
            },
            failure: { error in
                print(error.description)
            }
        )
    }
    
    func getFitBitFoodLog(_ oauthswift: OAuth2Swift) {
        formatter.dateFormat = "yyyy-MM-dd"
        let todaysDate = formatter.string(from: date)
        
        let _ = oauthswift.client.get(
            "https://api.fitbit.com/1/user/-/foods/log/date/\(todaysDate).json",
            parameters: [:],
            success: { response in
                let dataString = response.string!
                do {
                    let json = try JSONDecoder().decode(FitBitResponse.self, from: dataString.data(using: .utf8)!)
                    let jsonFoods = json.foods
                    let jsonFoodsLength = jsonFoods.count
                    for index in 0..<jsonFoodsLength {
                        let foodName = json.foods[index].loggedFood.name
                        if self.foodsInDB.contains(foodName) {
                            self.fitbitFoods.append(foodName)
                        } else if specialWords.keys.contains(foodName){
                            self.fitbitFoods.append(specialWords[foodName]!)
                        }
                    }
                    self.allFitBitFoods = self.fitbitFoods
                    print(self.fitbitFoods)
                }
                catch {
                    print(error)
                    self.loadingView.stopAnimating()
                }
        },
            failure: { error in
                print(error.description)
            }
        )
    }
    
    func getURLHandler() -> OAuthSwiftURLHandlerType {
        let handler = SafariURLHandler(viewController: self, oauthSwift: self.oauthswift!)
        handler.presentCompletion = {
            print("Safari presented")
        }
        handler.dismissCompletion = {
            self.loadingView.startAnimating()
            self.compareLoggedFoods()
            print("Safari dismissed")
        }
        return handler
    }
    
    func getFoodInfoFromDatabase(foodName: String) {
        ref.child("Produce").child(foodName).observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? [String:Any] {
                let food = FoodStruct(name: foodName, quantity: (data["Quantity"] as? String)!, calcium: (data["Calcium"] as? String)!, vitaminA: (data["VitaminA"] as? String)!, vitaminC: (data["VitaminC"] as? String)!, iron: (data["Iron"] as? String)!, potassium: (data["Potassium"] as? String)!)
                
                let calciumFloat = self.extractNutrionalFloat(nutritionalString: (data["Calcium"] as? String)!)
                let ironFloat = self.extractNutrionalFloat(nutritionalString: (data["Iron"] as? String)!)
                let potassiumFloat = self.extractNutrionalFloat(nutritionalString: (data["Potassium"] as? String)!)
                let vitaminAFloat = self.extractNutrionalFloat(nutritionalString: (data["VitaminA"] as? String)!)
                let vitaminCFloat = self.extractNutrionalFloat(nutritionalString: (data["VitaminC"] as? String)!)
                
                self.calFloat += calciumFloat
                self.irnFloat += ironFloat
                self.potFloat += potassiumFloat
                self.vitAFloat += vitaminAFloat
                self.vitCFloat += vitaminCFloat
                
                self.multiFoodItems.append(food)
                print(self.multiFoodItems)
            }
        }
    }
    
    func getAllFoodInfoFromDatabase() {
        for item in self.fitbitFoods {
            print(item)
            self.getFoodInfoFromDatabase(foodName: item)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            print(self.multiFoodItems)
            print("Adding to DB")
            self.addItemsToDB()
        }
    }
    
    func compareLoggedFoods() {
        guard let uuid = Auth.auth().currentUser?.uid else { return }
        
        let todaysDate = self.getTodaysDate()
        
        ref.child("user").child("profile").child(uuid).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(todaysDate){        self.ref.child("user").child("profile").child(uuid).child(todaysDate).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let data = snapshot.value as? [String:Any] {
                            let loggedFoods = data["fitBitFoods"] as? String ?? ""
                            print(loggedFoods)
                            var loggedFoodsArr = loggedFoods.components(separatedBy: " ")

                            for food in self.fitbitFoods {
                                print(loggedFoodsArr)
                                print(self.fitbitFoods)
                                for loggedFood in loggedFoodsArr {
                                    if food == loggedFood {
                                        if let index = self.fitbitFoods.firstIndex(of: food) {
                                            self.fitbitFoods.remove(at: index)
                                        }
                                        if let index = loggedFoodsArr.firstIndex(of: loggedFood) {
                                            loggedFoodsArr.remove(at: index)
                                        }
                                        break
                                    }
                                }
                            }
                            print(self.fitbitFoods)
                            self.getAllFoodInfoFromDatabase()
                        }
                    }
                )
            }
        })
    }
    
    func addToDatabase(completion: @escaping ((_ success:Bool)->())) {
        guard let uuid = Auth.auth().currentUser?.uid else { return }
        
        let todaysDate = self.getTodaysDate()

        print("Has Date")
        self.updateUserProfile(date: todaysDate, uuid: uuid) { success in
            if success {
                print("Profile Saved")
                self.loadingView.stopAnimating()
                self.presentAlert(title: "Successful Fitbit Sync", message: "\(self.fitbitFoods.joined(separator: ", ")) added to your profile")
            }
        }
    }
    
    func extractNutrionalFloat(nutritionalString: String) -> Float {
        let nutritionStringArray : [String] = nutritionalString.components(separatedBy: " ")
        let nutritionFloat : Float? = Float(nutritionStringArray[0])
        
        return nutritionFloat ?? 0.00
    }
    
    func updateUserProfile(date: String, uuid: String, completion: @escaping ((_ success:Bool)->()) ) {
        ref.child("user").child("profile").child(uuid).child(date).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String:Any] {
                print("Updating DB")
                
                let userCalciumFloat = self.extractNutrionalFloat(nutritionalString: (data["calciumIntake"] as? String)!)
                let userIronFloat = self.extractNutrionalFloat(nutritionalString: (data["ironIntake"] as? String)!)
                let userPotassiumFloat = self.extractNutrionalFloat(nutritionalString: (data["potassiumIntake"] as? String)!)
                let userVitaminAFloat = self.extractNutrionalFloat(nutritionalString: (data["vitaminAIntake"] as? String)!)
                let userVitaminCFloat = self.extractNutrionalFloat(nutritionalString: (data["vitaminCIntake"] as? String)!)
                
                let newCalciumFloat : Float = userCalciumFloat + self.calFloat
                let newIronFloat : Float = userIronFloat + self.irnFloat
                let newPotassiumFloat : Float = userPotassiumFloat + self.potFloat
                let newVitaminAFloat : Float = userVitaminAFloat + self.vitAFloat
                let newVitaminCFloat : Float = userVitaminCFloat + self.vitCFloat
                
                let newRef = self.ref.child("user/profile/\(uuid)/\(date)")
                let consumedObject = ["calciumIntake" : String(format: "%.1f mg", newCalciumFloat),
                                      "ironIntake" : String(format: "%.1f mg", newIronFloat),
                                      "vitaminAIntake" : String(format: "%.1f ug", newVitaminAFloat),
                                      "vitaminCIntake" : String(format: "%.1f mg", newVitaminCFloat),
                                      "potassiumIntake": String(format: "%.1f mg", newPotassiumFloat),
                                      "fitBitFoods": "\(self.allFitBitFoods.joined(separator: " "))"]
                
                print(self.allFitBitFoods.joined(separator: " "))
                newRef.updateChildValues(consumedObject) { error, dbref in
                    completion(error == nil)
                }
            }
        })
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
