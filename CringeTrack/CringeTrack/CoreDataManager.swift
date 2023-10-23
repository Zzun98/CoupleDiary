//
//  CoreDataManager.swift
//  CringeTrack
//
//  Created by Christopher Averkos on 22/10/2023.
//

import Foundation
class CoreDataManager {
    static let context = PersistenceController.shared.container.viewContext
    
    //this will store a memory onto the CoreData after the user adds a photo and description
    static func saveMemory(coupleMemory: CoupleMemory) {
        let newMemory = Memory(context: context)
        /*guard let image = coupleMemory.image, let imageData = image.image.jpegData(compressionQuality: 1.0) else {
            fatalError("Unable to decode image data.")
        }*/
        
        
    }
}
