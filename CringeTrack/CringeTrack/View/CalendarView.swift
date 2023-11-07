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
                    let daysInMonth = currentMonth.daysInMonth()
                    let firstDayOfMonth = currentMonth.firstDayOfMonth().dayOfWeek() // Needs to return an Int 0-6 representing Sun-Sat
                    let offset = firstDayOfMonth
                    let totalDaysShown = 6 * 7
                    let totalCells = daysInMonth + offset
                    
                    ForEach(0..<totalDaysShown) { cell in
                            if cell < offset || cell >= totalCells {
                                Text("") // Empty cells before the first day of the month and after the last day
                            } else {
                                Text("\(cell - offset + 1)") // Actual day numbers
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
