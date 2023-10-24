//
//  CoreDataManager.swift
//  CringeTrack
//
//  Created by Christopher Averkos on 22/10/2023.
//

import Foundation
import SwiftUI
import CoreData

class CoreDataManager {
    static let context = PersistenceController.shared.container.viewContext
    
    //this will store a memory onto the CoreData after the user adds a photo and description
    static func saveMemory(coupleMemory: CoupleMemory, coupleUiImage: UIImage?) throws {
        let newMemory = Memory(context: context)
        guard let image = coupleUiImage, let imageData = image.jpegData(compressionQuality: 1.0) else {
            fatalError("Unable to decode image data.")
        }
        newMemory.memoryDate = coupleMemory.memoryDate
        newMemory.memoryDescription = coupleMemory.description
        newMemory.imageData = imageData
        
        //saves it to the database
        try context.save()
    }
}
