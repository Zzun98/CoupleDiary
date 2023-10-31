//
//  HomeView.swift
//  CringeTrack
//
//  Created by Sunjun Kwak on 16/10/2023.
//

import SwiftUI

// for the array of days the couple met
struct DateItem {
    let title: String
    var date: Date
    //this is a string computed property that will return a date in a date format for the user to view.
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    //this is a computed property to determine if the day has passed or not and returns in a boolean
    var isDaysPassed: Bool {
        return date <= Date()
    }
}

struct HomeView: View {
    @Environment(\.managedObjectContext) var contet
    @EnvironmentObject var coupleDiaryMain: CoupleDiaryMain
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Partner.primaryPartner, ascending: false)],
        animation: .default)
    private var partners: FetchedResults<Partner>
    // fetch today's date
    let currentDate: String = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter.string(from: Date())
        }()
    
    
    
    // date can be filled later with what the user sets
    var dateItems: [DateItem] {
        let dateItemArray: [DateItem] = [
            DateItem(title: "Day we met", date: coupleDiaryMain.dateMet),
            DateItem(title: "100 days", date: self.getDateFromDaysOnly(days: 100) ),
            DateItem(title: "200 days", date: self.getDateFromDaysOnly(days: 200)),
            DateItem(title: "300 days", date: self.getDateFromDaysOnly(days: 300)),
            DateItem(title: "1 year", date: self.getDateFromFirstMetToCurrent(days: nil, month: nil, year: 1)),
            DateItem(title: "2 years", date: self.getDateFromFirstMetToCurrent(days: nil, month: nil, year: 2)),
            DateItem(title: "3 years", date: self.getDateFromFirstMetToCurrent(days: nil, month: nil, year: 3)),
            DateItem(title: "4 years", date: self.getDateFromFirstMetToCurrent(days: nil, month: nil, year: 4)),
            DateItem(title: "5 years",date: self.getDateFromFirstMetToCurrent(days: nil, month: nil, year: 5)),
            DateItem(title: "6 years", date: self.getDateFromFirstMetToCurrent(days: nil, month: nil, year: 6)),
            DateItem(title: "7 years", date: self.getDateFromFirstMetToCurrent(days: nil, month: nil, year: 7)),
            DateItem(title: "8 years", date: self.getDateFromFirstMetToCurrent(days: nil, month: nil, year: 8)),
            DateItem(title: "9 years", date: self.getDateFromFirstMetToCurrent(days: nil, month: nil, year: 9)),
            DateItem(title: "10 years", date: self.getDateFromFirstMetToCurrent(days: nil, month: nil, year: 10))
        ]
        return dateItemArray
    }
    
    var sortedDateItems: [DateItem] {
        return renderListOfDatesWithBirthdays()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    // The rectangle is a placeholder for now - needs to be replaced with an image later
                    Rectangle()
                    //.resizable()
                    //.aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: 220)
                    //delete this line of code later when we find an okay image
                        .foregroundColor(.white)
                        .overlay(Color.black.opacity(0.4))
                        .clipped()
                    
                    VStack {
                        Text("Today: \(currentDate)")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        
                        HStack {
                            // Need to modify this code so that the number would change depending on the days passed since the first day the couple met
                            Text("\(coupleDiaryMain.totalDaysMet)")
                                .font(.system(size: 96, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("days")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                    }
                    
                }
                
                // ListView for number of days the couple met - need to connect with Model & ViewModel
                List(sortedDateItems, id: \.title) { item in
                    NavigationLink {
                        AlbumView(daysString: item.title, endDate: item.date)
                    } label: {
                        HStack {
                            Text(item.title)
                                .font(.system(size: 24, weight: .bold))
                            Spacer()
                            Text(item.formattedDate)
                                .font(.system(size: 16, weight: .medium))
                        }
                        
                        .listRowSeparatorTint(.black)
                    }.disabled(!item.isDaysPassed)
                 
                }
                .listStyle(.plain)
                .environment(\.defaultMinListRowHeight, 60)
            }.onAppear(perform: {
                //loads onboarding data that is stored in CoreData including date met.
                coupleDiaryMain.loadOnboarding()
        })
        }
   
    }
    
    
    //this is a function that will return the date from the original date to the numbers of days specified for date item.
    func getDateFromFirstMetToCurrent(days: Int?, month: Int?, year: Int?) -> Date {
        let calendar = Calendar.current
        let addedDates =  calendar.date(byAdding: DateComponents(year: year, month: month, day: days), to: coupleDiaryMain.dateMet)
        return addedDates!
        
    }
    
    func getDateFromDaysOnly(days: Int) -> Date {
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .day, value: days, to: coupleDiaryMain.dateMet)
        return newDate!
    }
    //this is a function that will return dates based on birthdays
    func renderListOfDatesWithBirthdays() -> [DateItem] {
        if partners.count == 2 {
            var tempDates: [DateItem] = dateItems
            let partner1Birthday = getcurrentBirthdayYear(dateOfBirth: partners[0].dateOfBirth ?? Date())
            let partner2Birthday = getcurrentBirthdayYear(dateOfBirth: partners[1].dateOfBirth ?? Date())
            if coupleDiaryMain.showBirthdayOnHomeView {
                tempDates.append(DateItem(title: "\(partners[0].name ?? "")'s Birthday", date: partner1Birthday))
                tempDates.append(DateItem(title: "\(partners[1].name ?? "")'s Birthday", date: partner2Birthday))
            }
            //returns the sorted dates array
            return tempDates.sorted(by: {$0.date < $1.date})
        } else {
            return dateItems
        }
        
        
        
    }
    
    //this is a function that will return the current birthday year instead of their date of birth.
    func getcurrentBirthdayYear(dateOfBirth: Date) -> Date {
        let calendar = Calendar.current
        let yearOnly = calendar.component(.year, from: Date())
        let monthOnly = calendar.component(.month, from: dateOfBirth)
        let dayOnly = calendar.component(.day, from: dateOfBirth)
        
        let newDateComp = DateComponents(calendar: calendar, year: yearOnly, month: monthOnly, day: dayOnly)
        
        return newDateComp.date!
    }
}

#Preview {
    HomeView()
}
