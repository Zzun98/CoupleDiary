//
//  CalendarView.swift
//  CringeTrack
//
//  Created by Sunjun Kwak on 16/10/2023.
//

import SwiftUI

struct CalendarView: View {
    @State private var currentMonth: Date = Date()
    @State private var selectedDate: Date = Date()
    //this will get the current month and year without the date where the date will always be on the first
    var monthAndYearOnly: Date {
        let calendar = Calendar.current
        let currentMonthDateComp = calendar.dateComponents([.month, .year], from: currentMonth)
        let newDateComp = DateComponents(calendar: calendar, year: currentMonthDateComp.year, month: currentMonthDateComp.month, day: 1)
        return newDateComp.date!
    }
        private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
   
    var body: some View {
        NavigationView {
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
                                NavigationLink {
                                    AlbumView(daysString: "\(navTitleFormatter.string(from: getDateFromView(day: day - currentMonth.firstDayOfMonth() + 1)))", endDate: getDateFromView(day: day - currentMonth.firstDayOfMonth() + 1))
                                } label: {
                                    Text("\(day - currentMonth.firstDayOfMonth() + 1)")
                                }
                                
                            }
                        }
                    }
                }
                .padding()
            }
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
    
    //this function will be called when the day is tapped.
    func getDateFromView(day: Int) -> Date {
        
        print("Tapped day \(day)")
        let selectedMonth = currentMonth
        let calendar = Calendar.current
        let tappedDate = calendar.date(bySetting: .day, value: day + 1, of: selectedMonth)
        return tappedDate ?? Date()
    }
        
    var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    var navTitleFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }
    
    
    
}


#Preview {
    CalendarView()
}
