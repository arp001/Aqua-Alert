//
//  ProfileViewController.swift
//  H2O
//
//  Created by Arpit Hamirwasia on 2016-11-02.
//  Copyright © 2016 Arpit. All rights reserved.
//

import UIKit
import KDCircularProgress
import ZFRippleButton
import Firebase
import PMAlertController

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var dateTellerLabel: UILabel!
    @IBOutlet weak var waterTargetLabel: UILabel!
    @IBOutlet weak var currentWaterLabel: UILabel!
    @IBOutlet weak var changeContainerButton: ZFRippleButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var plusButton: ZFRippleButton!
    let customDate = CustomDate(date: Date())
    var progress: KDCircularProgress!
    let ref = FIRDatabase.database().reference()
    var waterTarget = UserDefaults.standard.integer(forKey: Constants.waterTargetKey)
    var waterCupSize = UserDefaults.standard.integer(forKey: Constants.cupSizeKey)
    var currentWater = UserDefaults.standard.integer(forKey: Constants.currentWaterKey)
    var profileOnDates : [String:NSDictionary]?
    
    private func setupPlusButton() {
        plusButton.rippleOverBounds = true
        plusButton.buttonCornerRadius = 12.0
        plusButton.clipsToBounds = true
        plusButton.layer.cornerRadius = 0.5 * plusButton.bounds.size.width
        plusButton.backgroundColor = .black
        plusButton.shadowRippleEnable = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear called!")
        unhideRow()
        dateTellerLabel.text = CustomDate(date: Date()).formatDate()
        tabBarController?.tabBar.isHidden = false
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: Constants.deltaKey)
        let uuid = Constants.uuid
        let keyForDate = customDate.formatDate()
        let dateRef = ref.child(uuid!).child("TimeInfo").child(keyForDate)
        func getData(completion: @escaping () -> ()) {
            dateRef.observeSingleEvent(of: .value, with: { (snapshot) in
                print("snapshot.value is: \(snapshot.value)")
                if snapshot.value as? NSDictionary == nil {
                    /* ok, so this means that this date hasn't yet been recorded in
                     Firebase which means that the user opened the application
                     on a completely new day ==> we have to reset the statistics.
                     But, the water target, cup Size for today and prev days remain same.
                     First, we add the new entry to FireBase and then set the class objects
                     to the right values using prev days' information. */
                    
                    defaults.set(false, forKey: Constants.didShowDailyAlertKey)
                    defaults.set(0.0, forKey: Constants.currentFromAngleKey)
                    defaults.set(0.0, forKey: Constants.currentRatioKey)
                    let array = [Record]()
                    let arrayArchived = NSKeyedArchiver.archivedData(withRootObject: array)
                    defaults.set(arrayArchived, forKey: Constants.histArrayKey)
                    defaults.synchronize()
                    self.waterTarget = defaults.integer(forKey: Constants.waterTargetKey)
                    self.waterCupSize = defaults.integer(forKey: Constants.cupSizeKey)
                    self.currentWater = 0
                    defaults.set(0, forKey: Constants.currentWaterKey)
                    let waterEntry = WaterInfo(wt: self.waterTarget, cw: 0, cs: self.waterCupSize)
                    dateRef.setValue(waterEntry.toDict())
                    completion()
                }
                else {
                    self.waterTarget = defaults.integer(forKey: Constants.waterTargetKey)
                    self.waterCupSize = defaults.integer(forKey: Constants.cupSizeKey)
                    self.currentWater = defaults.integer(forKey: Constants.currentWaterKey)
                    let ratio = (Double(self.currentWater)/Double(self.waterTarget))
                    let currentFromAngle = ratio * 360.0
                    UserDefaults.standard.set(currentFromAngle, forKey: Constants.currentFromAngleKey)
                    UserDefaults.standard.set(ratio, forKey: Constants.currentRatioKey)
                    completion()
                }
            })
        }
        
        getData {
            print("in completion")
            self.setupProgress()
            self.updateLabels()
            self.setupContainerButton()
        }
        setupPlusButton()
    }
    
    private func setupProgress() {
        let defaults = UserDefaults.standard
        let ratio = defaults.double(forKey: Constants.currentRatioKey)
        let showRatio = min(1.0,ratio)
        print("in setupProgress")
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        view.backgroundColor = UIColor(white: 0.22, alpha: 1)
        progressLabel.text = String(Int(ratio * 100.0)) + "%"
        progress.startAngle = -90
        progress.progressThickness = 0.4
        progress.trackThickness = 0.6
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .forward
        progress.glowAmount = 0.9
        updateProgressColor(ratio: ratio)
        progress.center = CGPoint(x: view.center.x, y: view.center.y - 25)
        view.addSubview(progress)
        let target = showRatio * 360.0
        defaults.set(target, forKey: Constants.currentFromAngleKey)
        progress.animate(0.0, toAngle: target, duration: 1.3, completion: { (completed) in
            
            if completed {
                print("animation stopped, completed")
            }
            else {
                print("animation stopped, was interrupted")
            }
        })
        print("out setupProgress")
    }
    
    private func setupContainerButton() {
        // need to figure this out later
        changeContainerButton.setTitle(String(waterCupSize) + " ML", for: .normal)
        changeContainerButton.shadowRippleEnable = true
        changeContainerButton.buttonCornerRadius = 15
        changeContainerButton.ripplePercent = 0.5
        changeContainerButton.rippleColor = .clear
        changeContainerButton.shadowRippleRadius = 0.5
        changeContainerButton.trackTouchLocation = true
        changeContainerButton.touchUpAnimationTime = 0
    }
    
    private func showDailyMessage() {
        
        func prepareToShowAlert(completion: @escaping (String) -> Void) {
            var desc = ""
            var mod = 0
            ref.child("facts").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                print("value is: \(value)")
                mod = value?["number"] as! Int
                let mod32 = UInt32(mod)
                let index = arc4random() % mod32 + 1
                desc = value?["fact" + String(index)] as! String
                print("desc is : \(desc)")
                completion(desc)
            })
        }
        
        prepareToShowAlert(){ (desc) in
            let alertVC = PMAlertController(title: "Did you know?", description: desc, image: nil, style: .alert)
            let okaction = PMAlertAction(title: "OK", style: .default, action: {() -> Void in
                // do something when OK is pressed
            })
            
            alertVC.alertTitle.textColor = .black
            alertVC.addAction(okaction)
            alertVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    private func updateLabels() {
        waterTargetLabel.text = String(waterTarget) + " ML"
        currentWaterLabel.text = String(currentWater) + " ML"
        print("waterTargetLabel.text: \(waterTargetLabel.text)")
        print("currentWaterLabel.text: \(currentWaterLabel.text)")
    }
    
    private func populateProfileOnDates() {
        func getData(completion: @escaping () -> ()) {
            let timeRef = ref.child(Constants.uuid!).child("TimeInfo")
            print("timeRef is: \(timeRef)")
            timeRef.observe(.value, with: { (snapshot) in
                let value = snapshot.value as? [String:NSDictionary]
                print("ppod value is: \(value)")
                self.profileOnDates = value
                completion()
            })
        }
        getData {
            print("profileondates is: \(self.profileOnDates)")
        }
    }
    
    private func setupNavAndTab() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(true, forKey: Constants.didLoginKey)
        populateProfileOnDates()
        setupNavAndTab()
    }
    
    private func showPopupAlert(message: String, title: String) {
        let alertVC = PMAlertController(title: title, description: message, image: nil, style: .alert)
        let okaction = PMAlertAction(title: "OK", style: .default, action: {() -> Void in
            // do something when OK is pressed
        })
        
        alertVC.alertTitle.textColor = .black
        alertVC.addAction(okaction)
        alertVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // if the user didn't already receive a daily popup, then show one
        if !(UserDefaults.standard.bool(forKey: Constants.didShowDailyAlertKey)) {
            showDailyMessage()
            UserDefaults.standard.set(true, forKey: Constants.didShowDailyAlertKey)
        }
    }

    private func updateProgressColor(ratio: Double) -> Void {
        if ratio < 0.3 {
            progress.set(.red)
        }
        else if ratio < 0.6 {
            progress.set(.orange)
        }
        else {
            progress.set(.blue)
        }
    }
    
    private func syncWithDailyHistory() {
        let calendar = Calendar.current
        let hours = calendar.component(.hour, from: Date())
        let minutes = calendar.component(.minute, from: Date())
        var time = ""
        if minutes % 10 == minutes {
           time = String(hours) + ":" + "0" + String(minutes) + "."
        }
        
        else {
            time = String(hours) + ":" + String(minutes) + "."
        }
        
        let newElement = Record(time: time, amount: String(waterCupSize))
        let arrayData = UserDefaults.standard.object(forKey: Constants.histArrayKey) as? Data
        if let arrayData = arrayData {
            let unarchivedArray = NSKeyedUnarchiver.unarchiveObject(with: arrayData) as? [Record]
            if var array = unarchivedArray {
                array.append(newElement)
                let arrayArchived = NSKeyedArchiver.archivedData(withRootObject: array)
                UserDefaults.standard.set(arrayArchived, forKey: Constants.histArrayKey)
                UserDefaults.standard.synchronize()
            }
        }
        else {
            print("it's nil!")
            var array = [Record]()
            array.append(newElement)
            let arrayArchived = NSKeyedArchiver.archivedData(withRootObject: array)
            UserDefaults.standard.set(arrayArchived, forKey: Constants.histArrayKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    @IBAction func plusButtonTapped(_ sender: ZFRippleButton) {
        print("water cup size here is \(waterCupSize)")
        syncWithDailyHistory()
        let defaults = UserDefaults.standard
        let uuid = Constants.uuid
        let currentFromAngle = defaults.double(forKey: Constants.currentFromAngleKey)
        currentWater += waterCupSize
        defaults.set(currentWater, forKey: Constants.currentWaterKey)
        let baseRef = ref.child(uuid!).child("TimeInfo").child(customDate.formatDate())
        baseRef.child("currentWater").setValue(currentWater)
        let ratio: Double = Double(currentWater) / Double(waterTarget)
        defaults.set(ratio, forKey: Constants.currentRatioKey)
        let showRatio = min(1.0,ratio)
        updateLabels()
        progressLabel.text = String(Int(ratio * 100.00)) + "%"
        if showRatio == 1.0 && defaults.bool(forKey: "didReach100%") == false {
            defaults.set(true, forKey: "didReach100%")
            showPopupAlert(message: "Good job! You're hydrated now 💧", title: "You met your daily target!")
        }
        
        if ratio >= 1.3 && defaults.bool(forKey: "didCross130%") == false {
            defaults.set(true, forKey: "didCross130%")
            showPopupAlert(message: "Remember, too much water is not good for the body!", title: "Don't drink too much!")
        }
        
        let toAngle: Double = showRatio * 360.0
        updateProgressColor(ratio: showRatio)
        progress.animate(currentFromAngle, toAngle: toAngle, duration: 0.5) { completed in
            if completed {
                print("animation stopped, completed")
            } else {
                print("animation stopped, was interrupted")
            }
        }
        defaults.set(toAngle, forKey: Constants.currentFromAngleKey)
    }
    
    private func hideRow() {
        plusButton.isHidden = true
        changeContainerButton.isHidden = true
    }
    
    private func unhideRow() {
        plusButton.isHidden = false
        changeContainerButton.isHidden = false
    }
    
    @IBAction func accessoryButtonClicked(_ sender: UIButton) {
        // assume user clicks on left accessory
        let defaults = UserDefaults.standard
        var delta = defaults.integer(forKey: Constants.deltaKey)
        switch sender.currentTitle! {
            case "left":
                delta -= 1
                break
            case "right":
                delta += 1
                break
            default: break
        }
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .day, value: delta, to: Date())
        let customNewDate = CustomDate(date: newDate!)
        
        if profileOnDates == nil {
            // fail gracefully 
            return
        }
        
        if delta != 0 {
            hideRow()
        }
        else {
            unhideRow()
        }
        
        if let info = profileOnDates?[customNewDate.formatDate()] {
            
            let currentWater = info["currentWater"] as! Int
            let waterTarget = info["waterTarget"] as! Int
            let ratio = Double(currentWater) / Double(waterTarget)
            progressLabel.text = String(Int(ratio * 100.0)) + "%"
            currentWaterLabel.text = String(currentWater) + " ML"
            waterTargetLabel.text = String(waterTarget) + " ML"
            dateTellerLabel.text = customNewDate.formatDate()
            let showRatio = min(1.0,ratio)
            let toAngle: Double = showRatio * 360.0
            updateProgressColor(ratio: showRatio)
            progress.animate(0.0, toAngle: toAngle, duration: 1.3) { completed in
                if completed {
                    print("animation stopped, completed")
                } else {
                    print("animation stopped, was interrupted")
                }
            }
            defaults.set(delta, forKey: Constants.deltaKey)
        }
        else {
            progressLabel.text = "0 %"
            currentWaterLabel.text = " - "
            waterTargetLabel.text = " - "
            dateTellerLabel.text = customNewDate.formatDate()
            updateProgressColor(ratio: 0.0)
            progress.animate(0.0, toAngle: 0.0, duration: 1.3) { completed in
                if completed {
                    print("animation stopped, completed")
                } else {
                    print("animation stopped, was interrupted")
                }
            }
            defaults.set(delta, forKey: Constants.deltaKey)
        }
    }
    
    
    @IBAction func changeContainerButtonPressed() {
        performSegue(withIdentifier: "showContainersSegue", sender: nil)
        changeContainerButton.setTitle(String(waterCupSize) + " ML", for: .normal)
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
