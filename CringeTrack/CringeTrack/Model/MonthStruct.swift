//
//  MonthStruct.swift
//  CringeTrack
//
//  Created by Sunjun Kwak on 18/10/2023.
//

// Model for CalendarView

import Foundation
import SwiftUI

extension Date {
    func daysInMonth() -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)!
        return range.count
    }
    
    func firstDayOfMonth() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }
    
    func dayOfWeek() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday! - 1 // Adjust to 0-index for Sunday
    }
}
