//
//  LogoView.swift
//  CringeTrack
//
//  Created by Sunjun Kwak on 16/10/2023.
//

import SwiftUI

// The LogoView screen will be shown a few seconds before the ContentView screen when the user opens the app.

struct LogoView: View {
    @State private var showAlert: Bool = false

    var body: some View {
        VStack {
            Text("Cringe Track")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            
            Image("CringeTrack")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 71, height: 65)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color(red: 0.96, green: 0.49, blue: 0.43)
            .ignoresSafeArea()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showAlert = true
            }
        }
        
        // Alert for asking user's permission to send notifications. This alert will only be shown upon the first login.
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Cringe Track would like to send you notifications"),
                message: Text("Notifications may include alerts and badges. These can be configured in Settings."),
                primaryButton: .default(Text("Allow"), action: {
                    
                }),
                secondaryButton: .cancel(Text("Don't Allow"))
            )
        }
    }
}

#Preview {
    LogoView()
}
