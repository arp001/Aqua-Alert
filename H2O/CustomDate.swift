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
    init(date: Date) {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        self.day = String(day)
        self.month = String(month)
        self.year = String(year)
    }
    func formatDate() -> String {
        return year + month + day
    }
}
