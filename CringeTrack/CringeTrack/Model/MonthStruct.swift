//
//  MonthStruct.swift
//  CringeTrack
//
//  Created by Sunjun Kwak on 18/10/2023.
//

// Model for CalendarView

import Foundation
import SwiftUI

struct MonthStruct {
    var monthType: MonthType
    var dayInt : Int
    func day() -> String {
        return String(dayInt)
    }
}

enum MonthType {
    case Previous
    case Current
    case Next
}
