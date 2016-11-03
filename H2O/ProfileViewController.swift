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

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var plusButton: ZFRippleButton!
    var progress: KDCircularProgress!
    override func viewWillAppear(_ animated: Bool) {
        plusButton.rippleOverBounds = true
        plusButton.buttonCornerRadius = 12.0
        plusButton.clipsToBounds = true
        plusButton.backgroundColor = .black
        plusButton.shadowRippleEnable = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.22, alpha: 1)
        
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        progress.startAngle = -90
        progress.progressThickness = 0.8
        progress.trackThickness = 0.6
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .forward
        progress.glowAmount = 0.9
        progress.set(.blue)
        progress.center = CGPoint(x: view.center.x, y: view.center.y - 25)
        view.addSubview(progress)
        // Do any additional setup after loading the view.
    }

    @IBAction func plusButtonTapped(_ sender: ZFRippleButton) {
        progress.animate(0, toAngle: 250, duration: 5) { completed in
            if completed {
                print("animation stopped, completed")
            } else {
                print("animation stopped, was interrupted")
            }
        }
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
