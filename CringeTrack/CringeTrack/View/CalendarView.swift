//
//  CalendarView.swift
//  CringeTrack
//
//  Created by Sunjun Kwak on 16/10/2023.
//

import SwiftUI

struct CalendarView: View {
    @State private var currentMonth: Date = Date()
        private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        
        var body: some View {
            VStack {
                // Month navigation
                HStack {
                    Button(action: previousMonth) {
                        Image(systemName: "arrow.left")
                    }
                    Spacer()
                    Text("\(currentMonth, formatter: monthYearFormatter)") // Display month and year
                    Spacer()
                    Button(action: nextMonth) {
                        Image(systemName: "arrow.right")
                    }
                }
                .padding()
                
                // Weekday headers
                HStack {
                    ForEach(daysOfWeek, id: \.self) { day in
                        Text(day)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // Days of the month
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(1..<(currentMonth.firstDayOfMonth() + currentMonth.daysInMonth())) { day in
                        if day < currentMonth.firstDayOfMonth() {
                            Text("")
                        } else {
                            Text("\(day - currentMonth.firstDayOfMonth() + 1)")
                        }
                    }
                }
            }
            .padding()
        }
        
        func nextMonth() {
            let calendar = Calendar.current
            if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
                currentMonth = nextMonth
            }
        }

        func previousMonth() {
            let calendar = Calendar.current
            if let prevMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
                currentMonth = prevMonth
            }
        }
        
        var monthYearFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            return formatter
        }
    }


#Preview {
    CalendarView()
}
