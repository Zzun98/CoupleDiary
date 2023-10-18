//
//  NotificationView.swift
//  CringeTrack
//
//  Created by Sunjun Kwak on 17/10/2023.
//

import SwiftUI

struct NotificationView: View {
    @State private var badgeOn = true
    @State private var bannerOn = true
    
    var body: some View {
        VStack(spacing: 60) {
            HStack {
                Text("Notifications")
                    .font(.system(size: 32, weight: .bold))
                Spacer() 
            }
            
            HStack {
                Toggle("Badges", isOn: $badgeOn)
                    .font(.system(size: 24, weight: .medium))
                Spacer()
            }
            
            HStack {
                Toggle("Banners", isOn: $bannerOn)
                    .font(.system(size: 24, weight: .medium))
                Spacer()
            }
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    NotificationView()
}
