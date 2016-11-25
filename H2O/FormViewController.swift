//
//  InitialViewController.swift
//  picker
//
//  Created by rbc on 2016-11-01.
//  Copyright © 2016 rbc. All rights reserved.
//

import UIKit
import Former
import Firebase

class InitialFormViewController: FormViewController {
    var ref: FIRDatabaseReference!
    var recommendedWaterIntake = 0
    var weight = 0.0
    var gender = "Male"
    var name = "Looool"
    var cameFromSettings = false 
    
    func calculateWaterIntake() -> String {
        let pickerWeight = weightInlinePickerRow.pickerItems[weightInlinePickerRow.selectedRow].title
        let weightInNumArray = pickerWeight.components(separatedBy: " ")
        let weightString = weightInNumArray[0]
        weight = Double(weightString)!
        gender = genderInlinePickerRow.pickerItems[genderInlinePickerRow.selectedRow].title
        let weightLbs = weight * 2.20462
        recommendedWaterIntake = Int(round(weightLbs * 0.43 * 29.5735))
        if gender == "Female" {
            recommendedWaterIntake += Int(round(0.08 * Double(recommendedWaterIntake)))
        }
        return String(recommendedWaterIntake)
    }
    
    let nameTextField = TextFieldRowFormer<FormTextFieldCell>().configure { (row) in
        row.placeholder = "Name"
        }.onSelected { (row) in
            
    }
    
    var weightInlinePickerRow = InlinePickerRowFormer<FormInlinePickerCell, Int>() {
        $0.titleLabel.text = "Weight"
        }.configure { row in
            row.pickerItems = (30...120).map {
                InlinePickerItem(title: "\($0)" + " kg", value: Int($0))
            }
        }.onValueChanged { item in
             
        }
    
    let suggestedWaterIntakeTextField = TextFieldRowFormer<FormTextFieldCell>().configure { (row) in
        row.placeholder = "Water intake/day Target (ml) "
    }
    
    let genderInlinePickerRow = InlinePickerRowFormer<FormInlinePickerCell, String>() {
        $0.titleLabel.text = "Gender"
        }.configure { row in
            row.pickerItems =  [InlinePickerItem(title: "Male", value: ""), InlinePickerItem(title: "Female", value: "")]
        }.onValueChanged { item in
            print("got here?")
    }
    
    
    let header = LabelViewFormer<FormLabelHeaderView>() { view in
        view.titleLabel.text = "Label Header"
    }

    
    @IBAction func confirmButtonPressed() {
        // handle incomplete profile here!
        var uniqueID = "" // creating a unique identifier for the person
        let defaults = UserDefaults.standard
        
        if cameFromSettings {
            uniqueID = Constants.uuid!
        }
        else {
            uniqueID = UUID().uuidString
        }
    
        
        // storing the profile info in Database
        let profile = UserInfo(name: nameTextField.text!, weight: weightInlinePickerRow.pickerItems[weightInlinePickerRow.selectedRow].title,  gender: genderInlinePickerRow.pickerItems[genderInlinePickerRow.selectedRow].title)
        let profileRef = ref.child(uniqueID).child("Personal")
        let timeRef = ref.child(uniqueID).child("TimeInfo").child(CustomDate(date: Date()).formatDate())
        profileRef.setValue(profile.toDict())
        timeRef.child("waterTarget").setValue(Int(suggestedWaterIntakeTextField.text!)!)
        if cameFromSettings {
            defaults.set(Int(suggestedWaterIntakeTextField.text!)!, forKey: Constants.waterTargetKey)
            let confirmationAlert = UIAlertController(title: "Success", message: "Your changes have been saved.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: { (result) in
                _ = self.navigationController?.popViewController(animated: true)
            })
            confirmationAlert.addAction(okButton)
            self.present(confirmationAlert, animated: true, completion: nil)
            return
        }
        
        let rec = calculateWaterIntake()
        func showRec(completion: @escaping () -> ()) {
            let alert = UIAlertController(title: "Recommended Water Intake", message: "According to your weight and gender, the recommended water intake for you is \(rec) ML per day. Would you like to use this estimate instead? You can edit it later in Settings.", preferredStyle: .alert)
            
            let yes = UIAlertAction(title: "Yes", style: .default, handler: { (result) in
                self.suggestedWaterIntakeTextField.text = rec
                completion()
            })
            
            let no = UIAlertAction(title: "No", style: .default, handler: { (result) in
                completion()
            })
            
            alert.addAction(no)
            alert.addAction(yes)
            self.present(alert, animated: true, completion: nil)
        }
        
        showRec {
            // storing water related info in Firebase (for graphing purposes)
            let waterInfo = WaterInfo(wt: Int(self.suggestedWaterIntakeTextField.text!)!, cw: 0, cs: 50)
            let customDate = CustomDate(date: Date())
            let dateRef = self.ref.child(uniqueID).child("TimeInfo").child(customDate.formatDate())
            dateRef.setValue(waterInfo.toDict())
            defaults.set(uniqueID, forKey: "identifier")
            Constants.uuid = uniqueID // storing the UID in UserDefaults
            
            // storing water info into UD
            defaults.set(waterInfo.containerSize, forKey: Constants.cupSizeKey)
            defaults.set(waterInfo.currentWater, forKey: Constants.currentWaterKey)
            defaults.set(waterInfo.waterTarget, forKey: Constants.waterTargetKey)
            self.performSegue(withIdentifier: "showTabBarVC", sender: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
        ref = FIRDatabase.database().reference()
        let section = SectionFormer(rowFormer: nameTextField, weightInlinePickerRow,genderInlinePickerRow,suggestedWaterIntakeTextField)
            .set(headerViewFormer: header)
        if Constants.uuid == nil {
            Constants.uuid = "Not set"
        }
        
        let personalRef = ref.child(Constants.uuid!).child("Personal")
        personalRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String:String]
            print("value is: \(value)")
            self.name = (value?["name"]) ?? ""
            print("name is: \(self.name)")
            self.gender = (value?["gender"]) ?? "Male"
            let weightWithKg = value?["weight"]
            let weightWithoutKgArray = weightWithKg?.components(separatedBy: " ")
            let weightWithoutKg = weightWithoutKgArray?[0] ?? "30"
            self.weight = Double(weightWithoutKg)!
            self.nameTextField.text = self.name
            self.weightInlinePickerRow.selectedRow = Int(self.weight - 30)
            self.suggestedWaterIntakeTextField.text = String(UserDefaults.standard.integer(forKey: Constants.waterTargetKey))
            if self.gender == "Male" {
               self.genderInlinePickerRow.selectedRow = 0
            }
            else {
               self.genderInlinePickerRow.selectedRow = 1
            }
            self.former.append(sectionFormer: section)
        })
    }
}

