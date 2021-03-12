//
//  Date+Timestamp.swift
//  Currency
//
//  Created by David Garcia Tort on 3/12/21.
//

import Foundation

extension Date {
    
    var iso8601Calendar: Calendar {
        let calendar = Calendar(identifier: .iso8601)
        return calendar
    }
    
    var iso8601Formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.calendar = iso8601Calendar
        return formatter
    }
    
    func minutesFromNow(date: Date) -> Int {
        let now = Date()
        let components = iso8601Calendar.dateComponents([.minute], from: date, to: now)
        return components.minute!
    }
}
