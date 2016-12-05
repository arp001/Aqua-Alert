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

    let ref = FIRDatabase.database().reference()
    let customDate = CustomDate(date: Date())
    
    @IBOutlet weak var container1: ZFRippleButton!
    @IBOutlet weak var container2: ZFRippleButton!
    @IBOutlet weak var container3: ZFRippleButton!
    @IBOutlet weak var container4: ZFRippleButton!
    @IBOutlet weak var container5: ZFRippleButton!
    @IBOutlet weak var container6: ZFRippleButton!
    func formatButton(button: ZFRippleButton){
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        if navigationController != nil {
            print("there is an nvc!")
        }
        else {
            print("no nvc")
        }
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.topViewController?.title = "Choose a Container Size"
        view.backgroundColor = UIColor(white: 0.22, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let arrayOfButtons = [container1, container2, container3, container4, container5, container6]
        for i in 0..<arrayOfButtons.count {
            formatButton(button: arrayOfButtons[i]!)
        }
    }
    
    func goToProfile() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func containerButtonPressed(_ sender: UIButton) {
        let buttonTitle = sender.titleLabel?.text
        var cupSize = 0
        let arrayOfStrings = buttonTitle?.components(separatedBy: " ")
        let numberString = arrayOfStrings?[0]
        cupSize = Int(numberString!)!
        print("cupsize is: \(cupSize)")
        let uuid = Constants.uuid
        let baseRef = ref.child(uuid!).child("TimeInfo").child(customDate.formatDate())
        baseRef.child("containerSize").setValue(cupSize)
        UserDefaults.standard.set(cupSize, forKey: Constants.cupSizeKey)
        goToProfile()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
}
