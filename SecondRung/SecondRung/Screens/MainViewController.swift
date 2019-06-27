//
//  MainViewController.swift
//  SecondRung
//
//  Created by O'Keeffe, Emma on 28/06/2018.
//  Copyright © 2018 O'Keeffe, Emma. All rights reserved.
//

import Foundation
import UIKit
import CoreML
import Vision
import Firebase
import FirebaseAuth
import Photos

class MainViewController: UIViewController, UINavigationControllerDelegate {
    
    let ref = Database.database().reference()

    @IBOutlet weak var imageLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "defaultImage")

        imageView.image = image
        
    }
    
    @IBAction func didTapChoosePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapCameraBtn(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func detectProduce(image: CIImage) {
        imageLabel.text = "Detecting Produce..."
        
        // Load the ML model through its generated class
        guard let model = try? VNCoreMLModel(for: FoodModel3().model) else {
            fatalError("Can't load ImageClassifier ML model")
        }
        
        // Create a Vision request with completion handler
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first else {
                    fatalError("Unexpected result type from VNCoreMLRequest")
            }
            
            // Update UI on main queue
            DispatchQueue.main.async { [weak self] in
                self?.imageLabel.text = "\(Int(topResult.confidence * 100))% confident it's a \(topResult.identifier.capitalized)"
                self?.presentPopOver(foodResultName: topResult.identifier)
            }
        }
        
        // Run the Core ML ImageClassifier classifier on global dispatch queue
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }
    
    func loadAlertBox(foodName: String, completion: @escaping ((_ success:Bool)->())) {
        let alert = UIAlertController(title: "Help us!", message: "We detected that your image is a \(foodName)🍴", preferredStyle: .alert)
        
        ref.child("MLAccuracy").child(foodName.capitalized).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String:Int] {
                var incorrect = Int(data["incorrect"]!)
                var correct = Int(data["correct"]!)
                
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
                    incorrect += 1
                    let newRef = self.ref.child("MLAccuracy/\(foodName.capitalized)")
                    
                    let consumedObject = ["incorrect" : incorrect]
                    
                    newRef.updateChildValues(consumedObject) { error, dbref in
                        completion(error == nil)
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    correct += 1
                    
                    let newRef = self.ref.child("MLAccuracy/\(foodName.capitalized)")
                    
                    let consumedObject = ["correct" : correct]
                    
                    newRef.updateChildValues(consumedObject) { error, dbref in
                        completion(error == nil)
                    }
                }))

                
            }
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentPopOver(foodResultName: String) {
        self.loadAlertBox(foodName: foodResultName) { success in
            if success {
                print("MLAccuracy Updated in DB")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navController = storyboard.instantiateViewController(withIdentifier: "FoodPopOverNavigationViewController")
                
                if let controller = navController.children.first as? FoodPopOverViewController {
                    
                    controller.foodName = foodResultName
                    self.imageView.accessibilityLabel = foodResultName
                    
                    navController.modalTransitionStyle = .coverVertical

                    self.present(navController, animated: true, completion: nil)
                }
            }
        }

    }

}


extension MainViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
//         Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
            else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        imageView.image = image

        guard let ciImage = CIImage(image: image) else {
            fatalError("Couldn't convert UIImage to CIImage")
        }
        
        detectProduce(image: ciImage)


        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
