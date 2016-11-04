//
//  ViewController.swift
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
    let nameTextField = TextFieldRowFormer<FormTextFieldCell>().configure { (row) in
        row.placeholder = "Name"
        }.onSelected { (row) in
            
    }
    
    let weightInlinePickerRow = InlinePickerRowFormer<FormInlinePickerCell, Int>() {
        $0.titleLabel.text = "Weight"
        }.configure { row in
            row.pickerItems = (30...120).map {
                InlinePickerItem(title: "\($0)" + "kg", value: Int($0))
            }
        }.onValueChanged { item in
            print("got here?")
    }
    
//    let labelRow = LabelRowFormer<FormLabelCell>()
//        .configure { row in
//            row.text = "Halloween!"
//        }.onSelected { row in
//            // Do Something
//    }
    
    let suggestedWaterIntake = TextFieldRowFormer<FormTextFieldCell>().configure { (row) in
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
        
        // this is our user profile
        let profile = UserInfo(name: nameTextField.text!, weight: weightInlinePickerRow.pickerItems[weightInlinePickerRow.selectedRow].title,  gender: genderInlinePickerRow.pickerItems[genderInlinePickerRow.selectedRow].title, water: suggestedWaterIntake.text!)
        // store data in Firebase
        let uniqueID = UUID().uuidString // creating a unique identifier for the person
        let defaults = UserDefaults.standard
        // storing the info in Database
        let profileRef = ref.child(uniqueID)
        profileRef.setValue(profile.toDict())
        defaults.set(uniqueID, forKey: "identifier") // storing the UID in UserDefaults
        //        let childRef = ref.child("arpit hamirwasia")
        //        // attach listeners and retrieve data
        //        childRef.updateChildValues(["isFun": "No"])
        //        childRef.observe(.value, with: {(snapshot) in
        //            print("data retrieved!")
        //            print(snapshot.value)
        //        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        let section = SectionFormer(rowFormer: nameTextField, weightInlinePickerRow,genderInlinePickerRow,suggestedWaterIntake)
            .set(headerViewFormer: header)
        former.append(sectionFormer: section)
    }
}

