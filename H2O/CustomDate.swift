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
        let monthDict = ["01":"Jan", "02": "Feb", "03": "March", "04": "April", "05": "May", "06":"June","07":"July","08": "Aug", "09": "Sept", "10": "Oct", "11": "Nov", "12": "Dec"]
        let monthName = monthDict[month]
        return monthName! + " " + day
    }
}
