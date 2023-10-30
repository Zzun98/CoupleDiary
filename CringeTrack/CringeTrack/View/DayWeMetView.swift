//
//  DayWeMetView.swift
//  CringeTrack
//
//  Created by Sunjun Kwak on 16/10/2023.
//

import SwiftUI
import UserNotifications

struct DayWeMetView: View {
    @State private var selectedDate = Date()
    let currentDate = Date()

    var body: some View {
        VStack(spacing: 100) {
            Text("When did you meet?")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.accentColor)
            
            // Need to change code so that the text "Pick a date..." itself becomes the datepicker
            DatePicker(
                "Pick a date...",
                selection: $selectedDate,
                in: ...currentDate,
                displayedComponents: .date
            )
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.56))
                .labelsHidden()
        }
    }
}

#Preview {
    DayWeMetView()
}
