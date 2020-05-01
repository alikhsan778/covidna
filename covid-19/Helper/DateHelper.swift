//
//  DateHelper.swift
//  covid-19
//
//  Created by margono on 01/05/20.
//  Copyright © 2020 manroelabs. All rights reserved.
//

import Foundation

struct DatePattern {
    static let full = "yyyy-MM-dd'T'HH:mm:ssZ"
    static let medium = "yyyy-MM-dd"
    static let day = "dd"
    
}

class DateHelper {
    
    private init(){}
    
    static func convertDateStringtoDate(date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = DatePattern.full
        return formatter.date(from: date)
    }
    
    static func convertDateToString(date: String) -> String {
        if let dateConverted = convertDateStringtoDate(date: date) {
            let formatter = DateFormatter()
            formatter.dateFormat = DatePattern.day
            return formatter.string(from: dateConverted)
        }
        return ""
    }
    
    static func convertDatetoString(date: Date, pattern: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = pattern
        return formatter.string(from: date)
    }
    
    static func addDaytoDate(date: Date, day: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.day = day
        return Calendar.current.date(byAdding: dateComponent, to: date) ?? Date()
    }
    
    static func getCurrentDate() -> Date {
        let currentDateString = convertDatetoString(date: Date(), pattern: DatePattern.medium)
        let currentDate = convertDateStringtoDate(date: currentDateString) ?? Date()
        return currentDate
    }
    
    static func getDateByComponent(day: Int, month: Int, year: Int) -> Date {
        let date = Date()
        var dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: date)

        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year

        return Calendar.current.date(from: dateComponents) ?? Date()
    }
}
