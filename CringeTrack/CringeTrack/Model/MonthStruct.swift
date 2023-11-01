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
    
    func firstDayOfMonth() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        let firstDay = calendar.date(from: DateComponents(year: components.year, month: components.month, day: 1))!
        return calendar.component(.weekday, from: firstDay)
    }
    
   
}
