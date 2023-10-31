//
//  InSessionView.swift
//  CringeTrack
//
//  Created by Christopher Averkos on 30/10/2023.
//

import SwiftUI

struct InSessionView: View {
    @State private var selection = 0
    var body: some View {
        
        TabView {
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    InSessionView()
}
