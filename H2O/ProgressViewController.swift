//
//  ProgressViewController.swift
//  H2O
//
//  Created by Arpit Hamirwasia on 2016-11-11.
//  Copyright © 2016 Arpit. All rights reserved.
//

import UIKit
import ScrollableGraphView
import Firebase

class ProgressViewController: UIViewController {
    
    
    @IBOutlet weak var customView: UIView!
    var graphConstraints = [NSLayoutConstraint]()
    var graphView = ScrollableGraphView()

    private func createBarGraph(_ frame: CGRect) -> ScrollableGraphView {
        graphView = ScrollableGraphView(frame:frame)
        
        graphView.dataPointType = ScrollableGraphViewDataPointType.circle
        graphView.shouldDrawBarLayer = true
        graphView.shouldDrawDataPoint = false
        graphView.lineWidth = 0.0
        graphView.backgroundFillColor = UIColor(white: 0.22, alpha: 1.0)
        graphView.barColor = .black
        graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        graphView.referenceLineLabelColor = UIColor.white
        graphView.numberOfIntermediateReferenceLines = 9
        graphView.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        graphView.shouldAnimateOnStartup = true
        graphView.adaptAnimationType = ScrollableGraphViewAnimationType.easeOut
        graphView.animationDuration = 0.5
        graphView.rangeMax = 3000
        graphView.shouldRangeAlwaysStartAtZero = true
        return graphView
    }
    
    private func setupConstraints() {
        
        self.graphView.translatesAutoresizingMaskIntoConstraints = false
        graphConstraints.removeAll()
        
        let topConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.customView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.customView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.customView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.customView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        
        //let heightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        
        graphConstraints.append(topConstraint)
        graphConstraints.append(bottomConstraint)
        graphConstraints.append(leftConstraint)
        graphConstraints.append(rightConstraint)
        
        //graphConstraints.append(heightConstraint)
        
        self.customView.addConstraints(graphConstraints)
    }
    
    func setupBarGraph() {
        let defaults = UserDefaults.standard
        let rect = CGRect(x: 0.0, y: 0.0 , width: customView.frame.width, height: customView.frame.height)
        graphView = createBarGraph(rect)
        // assert len (data) == len (labels) 
        
        let ref = FIRDatabase.database().reference()
        let uuid = defaults.string(forKey: "identifier")
        var baseRef = ref.child(uuid!).child("TimeInfo")
        var dict = [String: Double]()
        func getData(completion: @escaping ([String:Double]) -> ()) {
            baseRef.observe(.value, with: { (snapshot) in
                let value = snapshot.value as? [String:NSDictionary]
                print("array is: \(value)")
                for (date,info) in value! {
                    let info = value?[date]
                    let toAppendInt = info?["currentWater"] as! Int
                    let toAppendDouble = Double(toAppendInt)
                    dict[date] = toAppendDouble
                }
                completion(dict)
            })
        }
        getData { (dictionary) in
            var data: [Double] = []
            var labels: [String] = []
            for (name,val) in dict {
                data.append(val)
                labels.append(name)
            }
            data.reverse()
            labels.reverse()
            self.graphView.set(data, withLabels: labels)
            self.customView.addSubview(self.graphView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarGraph()
        self.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false 
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
