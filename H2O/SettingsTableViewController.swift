//
//  SettingsTableViewController.swift
//  H2O
//
//  Created by Arpit Hamirwasia on 2016-11-22.
//  Copyright © 2016 Arpit. All rights reserved.
//


import UIKit
import PMAlertController
import UserNotifications

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationItem.setHidesBackButton(true, animated: false)
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
            case 0,2:
                return 1
            case 1:
                return 2
            default:
                return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 0 {
            return nil
        }
        else if indexPath.section == 2 {
            return nil
        }
        
        return indexPath
    }
    
    func scheduleLocal(freq: Int) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        let content = UNMutableNotificationContent()
        content.title = "Water Reminder"
        content.body = "It's time to drink a glass of water!"
        content.categoryIdentifier = "notif"
        content.userInfo = ["customData": "fillerInfo"]
        content.sound = UNNotificationSound.default()
        var dateComponents = DateComponents()
        dateComponents.hour = freq/60
        dateComponents.minute = freq%60
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath is: \(indexPath)")
        let cell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        switch cell.reuseIdentifier! {
            case "changeCell":
                performSegue(withIdentifier: "showInitialFormSegue", sender: nil)
                break
            case "freqCell":
                let choices = PMAlertController(title: "Choose an interval", description: "", image: nil, style: .walkthrough)
                choices.gravityDismissAnimation = false
                choices.alertTitle.textColor = .blue
                let minutes = [15,30,45]
            
                for i in minutes {
                    let alertAction = PMAlertAction(title: "Every " + String(i) + " minutes", style: .default, action: { (result) in
                        print("i: \(i)")
                        self.scheduleLocal(freq: i)
                    })
                    choices.addAction(alertAction)
                }
            
                let hours = [1,2,3,4]
            
                for i in hours {
                    var time = ""
                    if i == 1 {
                        time = " hour"
                    }
                    else {
                        time = " hours"
                    }
                    
                    let alertAction = PMAlertAction(title: "Every " + String(i) + time, style: .default, action: { (result) in
                        self.scheduleLocal(freq: i*60)
                    })
                    choices.addAction(alertAction)
                }
                
                self.present(choices, animated: true, completion: nil)
                break
            default: break
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showInitialFormSegue" {
           let destinationVC = segue.destination as? InitialFormViewController
           destinationVC?.cameFromSettings = true
        }
    }
}
