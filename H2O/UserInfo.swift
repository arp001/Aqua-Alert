//
//  UserInfo.swift
//  H2O
//
//  Created by Arpit Hamirwasia on 2016-11-01.
//  Copyright © 2016 Arpit. All rights reserved.
//

import Foundation

class UserInfo {
    var name: String
    var weight: String
    var weightUnit: String
    var gender: String
    init(name: String, weight: String, weightUnit: String, gender: String){
        self.name = name
        self.weight = weight
        self.weightUnit = weightUnit
        self.gender = gender
    }
}
