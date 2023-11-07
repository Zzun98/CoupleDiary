//
//  SettingsViewModel.swift
//  CringeTrack
//
//  Created by Denni O on 11/7/23.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    func shareApp() -> [Any] {
        let message = "Check out this awesome app!"
        if let appURL = URL(string: "https://itunes.apple.com/app/your-app-id") {
            return [message, appURL]
        }
        return []
    }
}


