//
//  PastDatesTableViewController.swift
//  SecondRung
//
//  Created by Emma O'Keeffe on 22/03/2019.
//  Copyright © 2019 O'Keeffe, Emma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class PastDatesTableViewController: UITableViewController {

    let ref = Database.database().reference()
    
    let dateFormatter = DateFormatter()
    
    var userDates = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.accessUserDatabaseInfo()
        configureTableView()
        //organise dates
        
    }
    
    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func isDate(date: String) -> Bool {
        dateFormatter.dateFormat = "dd-MM-yyyy"
        if dateFormatter.date(from: date) != nil {
            return true
        } else {
            return false
        }
    }
    
    func accessUserDatabaseInfo() {
        guard let uuid = Auth.auth().currentUser?.uid else { return }
        
        ref.child("user").child("profile").child(uuid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let userData = snapshot.value as? [String:Any] {
                for data in userData.keys {
                    if self.isDate(date: data) {
                        self.userDates.append(data)
                    }
                }
                self.userDates = self.userDates.sorted()
                self.tableView.reloadData()
            }
        })
    }
    
    func presentPopOver(dateName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navController = storyboard.instantiateViewController(withIdentifier: "PastDatePopOverNavigationViewController")
        
        if let controller = navController.children.first as? DatePopOverViewController {
            
            controller.dateName = dateName
            
            navController.modalTransitionStyle = .coverVertical
            
            self.present(navController, animated: true, completion: nil)
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userDates.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = userDates[indexPath.row]
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name:"Helvetica-Bold", size: 20.0)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let date = userDates[indexPath.row]
            self.presentPopOver(dateName: date)
    }
}
