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
    var date: String
}

struct HomeView: View {
    
    // fetch today's date
    let currentDate: String = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter.string(from: Date())
        }()
    
    // date can be filled later with what the user sets
    let dateItems: [DateItem] = [
            DateItem(title: "Day we met", date: ""),
            DateItem(title: "100 days", date: ""),
            DateItem(title: "200 days", date: ""),
            DateItem(title: "300 days", date: ""),
            DateItem(title: "1 year", date: ""),
            DateItem(title: "2 years", date: ""),
            DateItem(title: "3 years", date: ""),
            DateItem(title: "4 years", date: ""),
            DateItem(title: "5 years", date: ""),
            DateItem(title: "6 years", date: ""),
            DateItem(title: "7 years", date: ""),
            DateItem(title: "8 years", date: ""),
            DateItem(title: "9 years", date: ""),
            DateItem(title: "10 years", date: "")
        ]
    
    var body: some View {
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
                        Text("1")
                            .font(.system(size: 96, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("days")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                }
                
            }
            
            // ListView for number of days the couple met - need to connect with Model & ViewModel
            List(dateItems, id: \.title) { item in
                HStack {
                    Text(item.title)
                        .font(.system(size: 24, weight: .bold))
                    Spacer()
                    Text(item.date)
                        .font(.system(size: 16, weight: .medium))
                }
                .listRowSeparatorTint(.black)
            }
            .listStyle(.plain)
            .environment(\.defaultMinListRowHeight, 60)
        }
    }
}

#Preview {
    HomeView()
}
