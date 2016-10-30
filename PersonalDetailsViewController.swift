//
//  PersonalDetailsViewController.swift
//  H2O
//
//  Created by Arpit Hamirwasia on 2016-10-29.
//  Copyright © 2016 Arpit. All rights reserved.
//

import UIKit

class PersonalDetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var genderLabel: UITextField!
    @IBOutlet weak var genderDropDown: UIPickerView!
    @IBOutlet weak var weightLabel: UITextField!
    @IBOutlet weak var unitsLabel: UITextField!
    
    @IBOutlet weak var unitsDropDown: UIPickerView!
    @IBOutlet weak var weightDropDown: UIPickerView!
    var weightList = [String]()
    var unitsList = [String]()
    var genderList = [String]()
    func setLists() {
        for i in 40...250 {
            weightList.append(String(i))
        }
        unitsList = ["kg","lb"]
        genderList = ["Male","Female"]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        if pickerView == weightDropDown {
            pickerLabel.text = String(weightList[row])
        }
        else if pickerView == unitsDropDown {
            pickerLabel.text = String(unitsList[row])
        }
        else if pickerView == genderDropDown {
            pickerLabel.text = String(genderList[row])
        }
        
        pickerLabel.textColor = UIColor.white
        pickerLabel.font = UIFont(name: "Menlo", size: 15)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    func setDelegatesAndDataSources() {
        unitsDropDown.dataSource = self
        unitsDropDown.delegate = self
        weightDropDown.dataSource = self
        weightDropDown.delegate = self
        weightLabel.delegate = self
        unitsLabel.delegate = self
        genderDropDown.delegate = self
        genderDropDown.dataSource = self
        genderLabel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        weightDropDown.isHidden = true
        unitsDropDown.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegatesAndDataSources()
        unitsLabel.addTarget(self, action: #selector(touchDetected), for: UIControlEvents.touchDown)
        weightLabel.addTarget(self, action: #selector(touchDetected), for: UIControlEvents.touchDown)
        genderLabel.addTarget(self, action: #selector(touchDetected), for: UIControlEvents.touchDown)
        setLists()
        // Do any additional setup after loading the view.
    }
    
    func touchDetected(textField: UITextField){
        // user touched on the label
        if textField == weightLabel {
            unitsDropDown.isHidden = true
            genderDropDown.isHidden = true
            weightDropDown.isHidden = false
        }
        else if textField == unitsLabel {
            genderDropDown.isHidden = true
            weightDropDown.isHidden = true
            unitsDropDown.isHidden = false
        }
        else if textField == genderLabel {
            weightDropDown.isHidden = true
            unitsDropDown.isHidden = true
            genderDropDown.isHidden = false
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        print("got here?")
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == unitsDropDown {
            return unitsList.count
        }
            
        else if pickerView == weightDropDown {
            return weightList.count
        }
        else if pickerView == genderDropDown {
            return genderList.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        if pickerView == unitsDropDown {
            return unitsList[row]
        }
        else if pickerView == weightDropDown {
            return weightList[row]
        }
        else if pickerView == genderDropDown {
            return genderList[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == unitsDropDown {
            self.unitsLabel.text = self.unitsList[row]
            self.unitsDropDown.isHidden = true;
        }
        
        else if pickerView == weightDropDown{
            self.weightLabel.text = self.weightList[row]
            self.weightDropDown.isHidden = true
        }
        else if pickerView == genderDropDown {
            self.genderLabel.text = self.genderList[row]
            self.genderDropDown.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
