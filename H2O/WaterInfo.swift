//
//  WaterInfo.swift
//  H2O
//
//  Created by Arpit Hamirwasia on 2016-11-06.
//  Copyright © 2016 Arpit. All rights reserved.
//

import Foundation

class WaterInfo {
    var waterTarget = 0
    var currentWater = 0
    var containerSize = 35
    
    init(wt: Int, cw: Int, cs: Int){
        waterTarget = wt
        currentWater = cw
        containerSize = cs 
    }
    
    func toDict() -> Any {
        return ["waterTarget":waterTarget, "currentWater": currentWater, "containerSize":containerSize]
    }
}
