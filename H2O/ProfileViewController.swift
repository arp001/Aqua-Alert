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
    var waterTarget = 0
    var waterCupSize = 35
    var currentWater = 0
    var currentAngle = 0.0
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
    }
    
    func setupProgress() {
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        view.backgroundColor = UIColor(white: 0.22, alpha: 1)
        progress.startAngle = -90
        progress.progressThickness = 0.6
        progress.trackThickness = 0.6
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .forward
        progress.glowAmount = 0.9
        progress.set(.red)
        progress.center = CGPoint(x: view.center.x, y: view.center.y - 25)
        view.addSubview(progress)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgress()
        let defaults = UserDefaults.standard
        let uuid = defaults.string(forKey: "identifier")
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
        let defaults = UserDefaults.standard
        let uuid = defaults.string(forKey: "identifier")
        progress.clockwise = true
        currentWater += waterCupSize
        ref.child(uuid!).child("currentWater").setValue(currentWater)
        let ratio: Double = min(1.0,Double(currentWater) / Double(waterTarget))
        progressLabel.text = String(Int(ratio * 100.00)) + "%"
        let toAngle: Double = ratio * 360.0
        updateProgressColor(ratio: ratio)
        print("Current angle in plus: \(currentAngle)")
        print("To angle in plus: \(toAngle)")
        progress.animate(currentAngle, toAngle: toAngle, duration: 0.5) { completed in
            if completed {
                print("animation stopped, completed")
            } else {
                print("animation stopped, was interrupted")
            }
        }
        currentAngle = toAngle
    }

    @IBAction func minusButtonTapped(_ sender: ZFRippleButton) {
        let defaults = UserDefaults.standard
        let uuid = defaults.string(forKey: "identifier")
        currentWater = max(currentWater - waterCupSize, 0)
        ref.child(uuid!).child("currentWater").setValue(currentWater)
        let ratio: Double = Double(currentWater) / Double(waterTarget)
        progressLabel.text = String(Int(ratio * 100)) + "%"
        let toAngle: Double = ratio * 360.0
        updateProgressColor(ratio: ratio)
        print("Current angle in minus: \(currentAngle)")
        print("To angle in minus: \(toAngle)")
        progress.animate(currentAngle, toAngle: toAngle, duration: 0.5) { completed in
            if completed {
                print("animation stopped, completed")
            } else {
                print("animation stopped, was interrupted")
            }
        }
        currentAngle = toAngle
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
