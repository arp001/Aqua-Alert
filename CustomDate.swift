//
//  CustomDate.swift
//  
//
//  Created by Arpit Hamirwasia on 2016-11-06.
//
//

import Foundation

class CustomDate {
    let day: String
    let month: String
    let year: String
    init(day:String, month: String, year: String) {
        self.day = day
        self.month = month
        self.year = year
    }
    func formatDate() -> String {
        return year + month + day
    }
}
