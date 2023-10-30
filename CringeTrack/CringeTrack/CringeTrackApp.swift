//
//  CringeTrackApp.swift
//  CringeTrack
//
//  Created by Sunjun Kwak on 15/10/2023.
//

import SwiftUI
import CoreData

@main struct CringeTrackApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        @StateObject var coupleDiaryMain = CoupleDiaryMain()
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext).environmentObject(coupleDiaryMain)
        }
    }
}
