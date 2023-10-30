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
    @StateObject var coupleDiaryMain = CoupleDiaryMain()
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext).environmentObject(coupleDiaryMain)
        }
    }
}
