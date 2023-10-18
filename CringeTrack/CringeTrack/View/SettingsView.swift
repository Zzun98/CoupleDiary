//
//  SettingsView.swift
//  CringeTrack
//
//  Created by Sunjun Kwak on 16/10/2023.
//

import SwiftUI

struct SettingsView: View {
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            List {
                settingRow(imageName: "Gift", text: "Birthdays")
                
                NavigationLink(destination: NotificationView()) {
                    settingRow(imageName: "Notification", text: "Notifications")
                }.buttonStyle(.plain)
                
                settingRow(imageName: "Cross", text: "Reset")
                    .onTapGesture {
                        showAlert = true
                    }
                
                settingRow(imageName: "Share", text: "Share")
            }
            .listStyle(.plain)
            .navigationTitle("Settings")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Reset all data?"),
                      message: Text("This cannot be undone."),
                      primaryButton: .destructive(Text("Reset")),
                      secondaryButton: .cancel())
            }
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
