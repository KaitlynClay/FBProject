//
//  ViewController.swift
//  FBProject
//
//  Created by student on 4/5/24.
//

import UIKit
import Firebase
import FirebaseFirestore

class ViewController: UIViewController {

    @IBOutlet weak var petName: UITextField!
    @IBOutlet weak var petAge: UITextField!
    @IBOutlet weak var petWeight: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    var db: Firestore!

        override func viewDidLoad() {
            super.viewDidLoad()
            db = Firestore.firestore()
        }
    

    @IBAction func addPet(_ sender: Any) {
        guard let name = petName.text,
              let ageText = petAge.text,
              let age = Int(ageText),
              let weightText = petWeight.text,
              let weight = Double(weightText) else {
            return
        }

        let petData: [String: Any] = [
            "name": name,
            "age": age,
            "weight": weight
        ]

        db.collection("pets").addDocument(data: petData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully!")
            }
        }
    }
    
    
    @IBAction func delPet(_ sender: Any) {
        guard let name = petName.text else {
            return
        }

        db.collection("pets").whereField("name", isEqualTo: name).getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    document.reference.delete()
                }
            }
        }
    }
    
    
    @IBAction func editPet(_ sender: Any) {
        guard let name = petName.text else {
            return
        }

        db.collection("pets").whereField("name", isEqualTo: name).getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    var petData = document.data()
                    if let ageText = self.petAge.text,
                       let age = Int(ageText) {
                        petData["age"] = age
                    }
                    if let weightText = self.petWeight.text,
                       let weight = Double(weightText) {
                        petData["weight"] = weight
                    }
                    document.reference.setData(petData)
                }
            }
        }
    }
    
    
    @IBAction func fetchPet(_ sender: Any) {
        db.collection("pets").getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                var resultText = ""
                for document in snapshot!.documents {
                    let petData = document.data()
                    if let name = petData["name"] as? String,
                       let age = petData["age"] as? Int,
                       let weight = petData["weight"] as? Double {
                        resultText += "\(name), Age: \(age), Weight: \(weight)\n"
                    }
                }
                self.resultLabel.text = resultText
            }
        }
    }
    
}

