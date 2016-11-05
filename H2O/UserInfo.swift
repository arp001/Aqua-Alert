//
//  UserInfo.swift
//  H2O
//
//  Created by Arpit Hamirwasia on 2016-11-01.
//  Copyright © 2016 Arpit. All rights reserved.
//

import Foundation
import Firebase

class UserInfo {
    let name: String
    let weight: String
    let gender: String
    let water: String
    let ref: FIRDatabaseReference?
    var cupSize = 35
    var currentWater = 0
    init(name: String, weight: String, gender: String, water: String){
        self.name = name
        self.weight = weight
        self.gender = gender
        self.water = water
        self.ref = FIRDatabase.database().reference()
    }
    func toDict() -> Any {
        return ["name": name, "weight": weight ,"gender":gender, "water": water, "currentWater": currentWater, "cupSize": cupSize]
    }
}
