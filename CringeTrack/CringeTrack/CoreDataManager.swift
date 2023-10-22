//
//  CoreDataManager.swift
//  CringeTrack
//
//  Created by Christopher Averkos on 22/10/2023.
//

import Foundation
class CoreDataManager {
    static let context = PersistenceController.shared.container.viewContext
}
