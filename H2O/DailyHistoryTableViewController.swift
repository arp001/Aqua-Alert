//
//  DailyHistoryTableViewController.swift
//  H2O
//
//  Created by Arpit Hamirwasia on 2016-11-16.
//  Copyright © 2016 Arpit. All rights reserved.
//

import UIKit

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
        let arrayData = UserDefaults.standard.object(forKey: "histArray") as? Data
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
        let alertVC = UIAlertController(title: "Undo this?", message: "This will be reflected on your profile.", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {(action) in
            // do something when yes is pressed
            self.histArray.remove(at: indexPath.row)
            let arrayArchived = NSKeyedArchiver.archivedData(withRootObject: self.histArray)
            UserDefaults.standard.set(arrayArchived, forKey: "histArray")
            UserDefaults.standard.synchronize()
            tableView.reloadData()
            let uuid = UserDefaults.standard.string(forKey: "identifier")
            //let ref = FIRDatabase.database().reference().child(uuid!)

        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in
            
        })
        
        alertVC.addAction(yesAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
