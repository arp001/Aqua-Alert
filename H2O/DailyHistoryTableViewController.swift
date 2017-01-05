//
//  DailyHistoryTableViewController.swift
//  H2O
//
//  Created by Arpit Hamirwasia on 2016-11-16.
//  Copyright © 2016 Arpit. All rights reserved.
//

import UIKit
import Firebase
class Record: NSObject, NSCoding {
    var time: String
    var amount: String
    init(time: String, amount:String){
        self.time = time
        self.amount = amount
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let time = aDecoder.decodeObject(forKey: "time") as! String
        let amount = aDecoder.decodeObject(forKey: "amount") as! String
        self.init(time: time, amount: amount)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(time, forKey: "time")
        aCoder.encode(amount, forKey: "amount")
    }
}

class DailyHistoryTableViewController: UITableViewController {
    
    var histArray = [Record]()
    private func getArray() {
        let arrayData = UserDefaults.standard.object(forKey: Constants.histArrayKey) as? Data
        if let arrayData = arrayData {
            let unarchivedArray = NSKeyedUnarchiver.unarchiveObject(with: arrayData) as? [Record]
            if let array = unarchivedArray {
                histArray = array
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = UIColor(white: 0.22, alpha: 1.0)
        getArray()
        print("histArray is: \(histArray)")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return histArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CustomTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.descLabel.text = "Drank " + (histArray[indexPath.row].amount) + " ML at " + (histArray[indexPath.row].time)
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let defaults = UserDefaults.standard
        let alertVC = UIAlertController(title: "Undo this?", message: "This will be reflected on your profile.", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: {(action) in
            // do something when yes is pressed
            var prevWater = defaults.integer(forKey: Constants.currentWaterKey)
            let amtString: String = self.histArray[indexPath.row].amount
            let amtInt = Int(amtString)!
            prevWater -= amtInt
            defaults.set(prevWater, forKey: Constants.currentWaterKey)
            let uuid = Constants.uuid
            let baseRef = FIRDatabase.database().reference().child(uuid!).child("TimeInfo").child(CustomDate(date: Date()).formatDate()).child("currentWater")
            baseRef.setValue(prevWater)
            self.histArray.remove(at: indexPath.row)
            let arrayArchived = NSKeyedArchiver.archivedData(withRootObject: self.histArray)
            defaults.set(arrayArchived, forKey: Constants.histArrayKey)
            defaults.synchronize()
            tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
            tableView.deselectRow(at: indexPath, animated: true)
        })
        
        alertVC.addAction(yesAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
