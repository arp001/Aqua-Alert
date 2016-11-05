//
//  SizeViewController.swift
//  H2O
//
//  Created by Arpit Hamirwasia on 2016-11-05.
//  Copyright © 2016 Arpit. All rights reserved.
//

import UIKit
import ZFRippleButton
import Firebase

class SizeViewController: UIViewController {

    @IBOutlet weak var container35: ZFRippleButton!
    let ref = FIRDatabase.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        if navigationController != nil {
            print("there is an nvc!")
        }
        else {
            print("no nvc")
        }
        
        container35.shadowRippleEnable = true
        container35.buttonCornerRadius = 10
        container35.ripplePercent = 0.5
        container35.rippleColor = .white
        container35.shadowRippleRadius = 0.2
        container35.rippleOverBounds = false
        container35.trackTouchLocation = true
        container35.touchUpAnimationTime = 1
        // Do any additional setup after loading the view.
    }

    @IBAction func containerButtonPressed(_ sender: UIButton) {
        let buttonTitle = sender.titleLabel?.text
        var cupSize = 0
        // might have to clean this up!
        switch buttonTitle! {
            case "35 ML":
                cupSize = 35
                break
            case "40 ML":
                cupSize = 40 
                break;
            case "45 ML":
                cupSize = 45
                break;
            case "50 ML":
                cupSize = 50
                break;
            case "55 ML":
                cupSize = 55
                break;
            case "60 ML":
                cupSize = 60
                break;
            case "65 ML":
                cupSize = 65
                break;
            case "70 ML":
                cupSize = 70
                break;
            default: break;
        }
        print("cupsize is: \(cupSize)")
        let defaults = UserDefaults.standard
        let uuid = defaults.string(forKey: "identifier")
        ref.child(uuid!).child("cupSize").setValue(cupSize)
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
