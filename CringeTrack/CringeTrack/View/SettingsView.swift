//
//  SettingsView.swift
//  CringeTrack
//
//  Created by Sunjun Kwak on 16/10/2023.
//

import SwiftUI

struct SettingsView: View {
    @State private var showAlert = false
    @State private var showErrorAlert = false
    @EnvironmentObject var coupleDiaryMain: CoupleDiaryMain
    var body: some View {
        NavigationView {
            List {
                settingRow(imageName: "Gift", text: "Birthdays")
                    .overlay {
                        NavigationLink(destination: BirthdayView()) {}
                            .opacity(0)
                    }
                    .listRowBackground(Spacer().background(.white))
                
                settingRow(imageName: "Notification", text: "Notifications")
                    .overlay {
                        NavigationLink(destination: NotificationView()) {}
                            .opacity(0)
                    }
                    .listRowBackground(Spacer().background(.white))
                
                settingRow(imageName: "Cross", text: "Reset")
                    .onTapGesture {
                        showAlert = true
                    }
                
                // Need to set up code for Share feature popup
                settingRow(imageName: "Share", text: "Share")
            }
            .listStyle(.plain)
            .environment(\.defaultMinListRowHeight, 60)
            .navigationTitle("Settings")
            .alert(isPresented: $showErrorAlert, content: {
                Alert(title: Text("Unable to reset CringeTrack"))
            })
        }.alert(isPresented: $showAlert) {
            Alert(title: Text("Reset all data?"),
                  message: Text("This cannot be undone."),
                  primaryButton: .destructive(Text("Reset"), action: {
                do {
                    //clears all CringeTrack data from the database including images, partner birthdays and days met.
                    try CoreDataManager.clearEverything()
                    //puts the view back to onboarding logo view
                    coupleDiaryMain.isSetup = false
                    //clears settings from user defaults
                    UserDefaultsManager.clearBirthdayState()
                } catch {
                    showErrorAlert = true
                }
            }),
              secondaryButton: .cancel())
        }
    }
    
    func settingRow(imageName: String, text: String) -> some View {
        HStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
            Spacer()
                .frame(width: 24)
            Text(text)
                .font(.system(size: 24, weight: .medium))
        }
        .listRowSeparator(.hidden)
    }
    
}

#Preview {
    SettingsView()
}
