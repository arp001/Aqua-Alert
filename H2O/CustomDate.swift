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
        let monthDict = ["1":"Jan", "2": "Feb", "3": "March", "4": "April", "5": "May", "6":"June","7":"July","8": "Aug", "9": "Sept", "10": "Oct", "11": "Nov", "12": "Dec"]
        let monthName = monthDict[month]
        return monthName! + " " + day
    }
}
