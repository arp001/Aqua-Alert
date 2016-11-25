//
//  Constants.swift
//  H2O
//
//  Created by Arpit Hamirwasia on 2016-11-13.
//  Copyright © 2016 Arpit. All rights reserved.
//

import Foundation
import Firebase

struct Constants {
    static var uuid = UserDefaults.standard.string(forKey: "identifier")
    static let currentWaterKey = "currentWaterKey"
    static let waterTargetKey = "waterTargetKey"
    static let cupSizeKey = "cupSizeKey"
    static let deltaKey = "deltaKey"
    static let currentRatioKey = "currentRatioKey"
    static let currentFromAngleKey = "currentFromAngleKey"
    static let didShowDailyAlertKey = "didShowDailyAlertKey"
    static let histArrayKey = "histArrayKey"
    static let didLoginKey = "didLoginKey"
    static let didAllowNotifKey = "didAllowNotifKey"
    static let didAllowPopupKey = "didAllowPopupKey"
}
