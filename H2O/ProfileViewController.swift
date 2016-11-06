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

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var minusButton: ZFRippleButton!
    @IBOutlet weak var plusButton: ZFRippleButton!
    var progress: KDCircularProgress!
    let ref = FIRDatabase.database().reference()
    var waterTarget = 20
    var waterCupSize = 35
    var currentWater = 0
    func setupPlusButton() {
        plusButton.rippleOverBounds = true
        plusButton.buttonCornerRadius = 12.0
        plusButton.clipsToBounds = true
        plusButton.backgroundColor = .black
        plusButton.shadowRippleEnable = true
    }
    
    func setupMinusButton() {
        minusButton.rippleOverBounds = true
        minusButton.buttonCornerRadius = 12.0
        minusButton.clipsToBounds = true
        minusButton.backgroundColor = .black
        minusButton.shadowRippleEnable = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupPlusButton()
        setupMinusButton()
        let defaults = UserDefaults.standard
        let uuid = defaults.string(forKey: "identifier")
        // Retrieving data from Firebase
        let childRefWaterIntake = ref.child(uuid!).child("water")
        childRefWaterIntake.observe(.value, with: { (snapshot) in
            let waterString = snapshot.value as! String
            self.waterTarget = Int(waterString)!
            print("waterTarget is : \(self.waterTarget)")
        })
        let childRefCurrentWater = ref.child(uuid!).child("currentWater")
        childRefCurrentWater.observe(.value, with: { (snapshot) in
            let currentWaterInt = snapshot.value as! Int
            self.currentWater = currentWaterInt
        })
        let childRefCupSize = ref.child(uuid!).child("cupSize")
        childRefCupSize.observe(.value, with: {(snapshot) in
            let currentCupSize = snapshot.value as! Int
            self.waterCupSize = currentCupSize
        })
    }
    
    func setupProgress() {
        let defaults = UserDefaults.standard
        let target = defaults.double(forKey: "currentFromAngle")
        let ratio = defaults.double(forKey: "currentRatio")
        print("in setupProgress")
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        view.backgroundColor = UIColor(white: 0.22, alpha: 1)
        progressLabel.text = String(Int(ratio * 100.0)) + "%"
        progress.startAngle = -90
        progress.progressThickness = 0.6
        progress.trackThickness = 0.6
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .forward
        progress.glowAmount = 0.9
        updateProgressColor(ratio: ratio)
        progress.center = CGPoint(x: view.center.x, y: view.center.y - 25)
        view.addSubview(progress)
        print("target is: \(target)")
        progress.animate(0.0, toAngle: target, duration: 0.5, completion: { (completed) in
            
            if completed {
                print("animation stopped, completed")
            }
            else {
                print("animation stopped, was interrupted")
            }
        })
        print("out setupProgress")
    }
    
    
    func updateProgessWhenViewLoads() {
        print("in updatePWVL")
        let defaults = UserDefaults.standard
        let targetAngle = defaults.double(forKey: "currentFromAngle")
        let currentRatio = defaults.double(forKey: "currentRatio")
        print("targetAngle is: \(targetAngle)")
        progressLabel.text = String(Int(currentRatio * 100.0)) + "%"
        updateProgressColor(ratio: currentRatio)
        progress.animate(0.0, toAngle: targetAngle, duration: 0.5) { completed in
            if completed {
                print("animation stopped, completed")
            } else {
                print("animation stopped, was interrupted")
            }
        }
        print("out updatePWVL")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgress()
        navigationController?.navigationBar.isHidden = false
        //updateProgessWhenViewLoads()
        
        print("cupSize is: \(self.waterCupSize)")
    }

    func updateProgressColor(ratio: Double) -> Void {
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
    
    @IBAction func plusButtonTapped(_ sender: ZFRippleButton) {
        print("water cup size here is \(waterCupSize)")
        let defaults = UserDefaults.standard
        let uuid = defaults.string(forKey: "identifier")
        let currentFromAngle = defaults.value(forKey: "currentFromAngle") as! Double
        currentWater += waterCupSize
        ref.child(uuid!).child("currentWater").setValue(currentWater)
        let ratio: Double = min(1.0,Double(currentWater) / Double(waterTarget))
        defaults.set(ratio, forKey: "currentRatio")
        progressLabel.text = String(Int(ratio * 100.00)) + "%"
        let toAngle: Double = ratio * 360.0
        updateProgressColor(ratio: ratio)
        print("Current angle in plus: \(currentFromAngle)")
        print("To angle in plus: \(toAngle)")
        progress.animate(currentFromAngle, toAngle: toAngle, duration: 0.5) { completed in
            if completed {
                print("animation stopped, completed")
            } else {
                print("animation stopped, was interrupted")
            }
        }
        defaults.set(toAngle, forKey: "currentFromAngle")
    }

    @IBAction func minusButtonTapped(_ sender: ZFRippleButton) {
        let defaults = UserDefaults.standard
        let uuid = defaults.string(forKey: "identifier")
        let currentFromAngle = defaults.value(forKey: "currentFromAngle") as! Double
        currentWater = max(currentWater - waterCupSize, 0)
        ref.child(uuid!).child("currentWater").setValue(currentWater)
        let ratio: Double = Double(currentWater) / Double(waterTarget)
        defaults.set(ratio, forKey: "currentRatio")
        progressLabel.text = String(Int(ratio * 100)) + "%"
        let toAngle: Double = ratio * 360.0
        updateProgressColor(ratio: ratio)
        print("Current angle in minus: \(currentFromAngle)")
        print("To angle in minus: \(toAngle)")
        progress.animate(currentFromAngle, toAngle: toAngle, duration: 0.5) { completed in
            if completed {
                print("animation stopped, completed")
            } else {
                print("animation stopped, was interrupted")
            }
        }
        defaults.set(toAngle, forKey: "currentFromAngle")
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
