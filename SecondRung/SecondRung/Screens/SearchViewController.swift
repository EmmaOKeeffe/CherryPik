//
//  SearchViewController.swift
//  SecondRung
//
//  Created by Emma O'Keeffe on 21/03/2019.
//  Copyright © 2019 O'Keeffe, Emma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SearchViewController: UIViewController {
    
    let ref = Database.database().reference()
    
    var foodNames = [String]()
    
    var searchFood = [String]()
    
    var searching = false

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFoodItems()
        configureTableView()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }
    
    func getFoodItems() {
        ref.child("Produce").observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? [String:Any] {
                for name in data.keys {
                    self.foodNames.append(name)
                }
                self.foodNames = self.foodNames.sorted()
                self.tableView.reloadData()
                
            }
        }
    }

    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func presentPopOver(foodResultName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navController = storyboard.instantiateViewController(withIdentifier: "FoodPopOverNavigationViewController")
        
        if let controller = navController.children.first as? FoodPopOverViewController {
            
            controller.foodName = foodResultName
            
            navController.modalTransitionStyle = .coverVertical
            self.present(navController, animated: true, completion: nil)
        }
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchFood.count
        } else {
            return foodNames.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        if searching {
            cell.textLabel?.text = searchFood[indexPath.row]
        } else {
            cell.textLabel?.text = foodNames[indexPath.row]
        }
        cell.textLabel?.textColor = UIColor.darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            let foodName = searchFood[indexPath.row]
            self.presentPopOver(foodResultName: foodName)
        } else {
            let foodName = foodNames[indexPath.row]
            self.presentPopOver(foodResultName: foodName)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchFood = foodNames.filter({$0.prefix(searchText.count) == searchText})
        searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        searchBar.endEditing(true)
        tableView.reloadData()
    }
}
