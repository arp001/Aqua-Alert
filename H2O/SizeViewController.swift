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
    var containerSize = 0
    
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
        self.performSegue(withIdentifier: "profileSegue", sender: nil)
    }
    
    @IBAction func containerButtonPressed(_ sender: UIButton) {
        let buttonTitle = sender.titleLabel?.text
        var cupSize = 0
        // might have to clean this up!
        switch buttonTitle! {
            case "50 ML":
                cupSize = 50
                break
            case "100 ML":
                cupSize = 100
                break
            case "150 ML":
                cupSize = 150
                break
            case "200 ML":
                cupSize = 200
                break
            case "400 ML":
                cupSize = 400
                break
            case "500 ML":
                cupSize = 500
                break
            default: break
        }
        print("cupsize is: \(cupSize)")
        let uuid = Constants.uuid
        let baseRef = ref.child(uuid!).child("TimeInfo").child(customDate.formatDate())
        baseRef.child("containerSize").setValue(cupSize)
        containerSize = cupSize
        self.performSegue(withIdentifier: "profileSegue", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        UserDefaults.standard.set(containerSize, forKey: Constants.cupSizeKey)
    }
}
