//
//  ViewController.swift
//  FBProject
//
//  Created by student on 4/5/24.
//

import UIKit
import Firebase
import FirebaseDatabaseInternal

class ViewController: UIViewController {

    @IBOutlet weak var petName: UITextField!
    @IBOutlet weak var petAge: UITextField!
    @IBOutlet weak var petWeight: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func addPet(_ sender: Any) {
        guard let name = petName.text,
              let age = Int(petAge.text ?? ""),
              let weight = Double(petWeight.text ?? "") else {
            return
        }
        let pet = ["name": name, "age": age, "weight": weight] as [String : Any]
        ref.child("pets").childByAutoId().setValue(pet)
    }
    
    
    @IBAction func delPet(_ sender: Any) {
        guard let name = petName.text else {
                return
            }
        ref.child("pets").observeSingleEvent(of: .value, with: { snapshot in
            for case let childSnapshot as DataSnapshot in snapshot.children {
                if let petDict = childSnapshot.value as? [String: Any],
                   let petName = petDict["name"] as? String,
                   petName == name {
                    childSnapshot.ref.removeValue()
                }
            }
        })
    }
    
    
    @IBAction func editPet(_ sender: Any) {
        guard let name = petName.text else {
                return
            }
        ref.child("pets").observeSingleEvent(of: .value, with: { snapshot in
            for case let childSnapshot as DataSnapshot in snapshot.children {
                if let petDict = childSnapshot.value as? [String: Any],
                   let petName = petDict["name"] as? String,
                   petName == name {
                    if let ageText = self.petAge.text,
                       let age = Int(ageText) {
                        childSnapshot.ref.child("age").setValue(age)
                    }
                    if let weightText = self.petWeight.text,
                       let weight = Double(weightText) {
                        childSnapshot.ref.child("weight").setValue(weight)
                    }
                }
            }
        })
    }
    
    
    @IBAction func fetchPet(_ sender: Any) {
        ref.child("pets").observeSingleEvent(of: .value, with: {snapshot in
        var resultText = ""
            for case let childSnapshot as DataSnapshot in snapshot.children {
                if let petDict = childSnapshot.value as? [String: Any],
                   let name = petDict["name"] as? String,
                   let age = petDict["age"] as? Int,
                   let weight = petDict["weight"] as? Double {
                    resultText += "\(name), Age: \(age), Weight: \(weight)\n"
                }
            }
            self.resultLabel.text = resultText
        })
    }
    
}

