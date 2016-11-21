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
    
    func calculateWaterIntake() {
        weight = Double(weightInlinePickerRow.pickerItems[weightInlinePickerRow.selectedRow].title)!
        gender = genderInlinePickerRow.pickerItems[genderInlinePickerRow.selectedRow].title
        let weightLbs = weight * 2.20462
        recommendedWaterIntake = Int(round(weightLbs * 0.43 * 29.5735))
        if gender == "Female" {
            recommendedWaterIntake += Int(round(0.08 * Double(recommendedWaterIntake)))
        }
        suggestedWaterIntakeTextField.text = String(recommendedWaterIntake) + " ML"
    }
    
    let nameTextField = TextFieldRowFormer<FormTextFieldCell>().configure { (row) in
        row.placeholder = "Name"
        }.onSelected { (row) in
            
    }
    
    var weightInlinePickerRow = InlinePickerRowFormer<FormInlinePickerCell, Int>() {
        $0.titleLabel.text = "Weight"
        }.configure { row in
            row.pickerItems = (30...120).map {
                InlinePickerItem(title: "\($0)" + "kg", value: Int($0))
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
        
        let uniqueID = UUID().uuidString // creating a unique identifier for the person
        let defaults = UserDefaults.standard
        
        // storing the profile info in Database
        let profile = UserInfo(name: nameTextField.text!, weight: weightInlinePickerRow.pickerItems[weightInlinePickerRow.selectedRow].title,  gender: genderInlinePickerRow.pickerItems[genderInlinePickerRow.selectedRow].title)
        let profileRef = ref.child(uniqueID).child("Personal")
        profileRef.setValue(profile.toDict())
        
        // storing water related info in Firebase (for graphing purposes)
        let waterInfo = WaterInfo(wt: Int(suggestedWaterIntakeTextField.text!)!, cw: 0, cs: 50)
        let customDate = CustomDate(date: Date())
        let dateRef = ref.child(uniqueID).child("TimeInfo").child(customDate.formatDate())
        dateRef.setValue(waterInfo.toDict())
        defaults.set(uniqueID, forKey: "identifier") // storing the UID in UserDefaults
        
        // storing water info into UD
        defaults.set(waterInfo.containerSize, forKey: Constants.cupSizeKey)
        defaults.set(waterInfo.currentWater, forKey: Constants.currentWaterKey)
        defaults.set(waterInfo.waterTarget, forKey: Constants.waterTargetKey)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        let section = SectionFormer(rowFormer: nameTextField, weightInlinePickerRow,genderInlinePickerRow,suggestedWaterIntakeTextField)
            .set(headerViewFormer: header)
        former.append(sectionFormer: section)
    }
}

