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
    let ref: FIRDatabaseReference?
    init(name: String, weight: String, gender: String){
        self.name = name
        self.weight = weight
        self.gender = gender
        self.ref = FIRDatabase.database().reference()
    }
    func toDict() -> Any {
        return ["name": name, "weight": weight ,"gender":gender]
    }
}
