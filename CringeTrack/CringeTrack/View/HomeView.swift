//
//  HomeView.swift
//  CringeTrack
//
//  Created by Sunjun Kwak on 16/10/2023.
//

import SwiftUI

struct HomeView: View {
    
    //fetch today's date
    let currentDate: String = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter.string(from: Date())
        }()
    
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
            List {
                HStack {
                    Text("Day we met")
                        .font(.system(size: 24, weight: .bold))
                    Spacer()
                    // Modify this code so that the corresponding dates would be shown instead
                    Text("filler")
                        .font(.system(size: 16, weight: .medium))
                }
                .listRowSeparatorTint(.black)
                
                HStack {
                    Text("100 days")
                        .font(.system(size: 24, weight: .bold))
                    Spacer()
                    // Modify this code so that the corresponding dates would be shown instead
                    Text("filler")
                        .font(.system(size: 16, weight: .medium))
                }
                .listRowSeparatorTint(.black)
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    HomeView()
}
