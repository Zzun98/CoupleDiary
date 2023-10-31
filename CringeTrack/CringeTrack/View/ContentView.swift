//
//  ContentView.swift
//  CringeTrack
//
//  Created by Sunjun Kwak on 15/10/2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var coupleDiaryMain: CoupleDiaryMain
    var body: some View {
       //this will display the logo view if the app does not have data stored.
        Group {
            if coupleDiaryMain.isSetup {
                InSessionView()
            } else {
                LogoView()
            }
        }.onAppear(perform: {
            //determines if onboarding data is already stored on the device
            coupleDiaryMain.isConfigured()
            coupleDiaryMain.loadBirthdayState()
        })
        
    }
}

#Preview {
    ContentView()
}
