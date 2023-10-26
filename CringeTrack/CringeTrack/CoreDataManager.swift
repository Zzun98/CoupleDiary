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
    static func saveMemory(coupleMemory: CoupleMemoryStruct) throws {
        let newMemory = Memory(context: context)
        newMemory.imageData = coupleMemory.imageData
        newMemory.memoryDate = coupleMemory.memoryDate
        newMemory.memoryDescription = coupleMemory.description
        
        //saves it to the database
        try context.save()
    }
    
    //this will only load data from CoreData and will not automatically convert it to an image as it is done from the frontend.
    static func loadAlbumns() throws -> [CoupleMemoryStruct] {
        let fetchRequest: NSFetchRequest<Memory> = Memory.fetchRequest()
        var coupleMemoryTemp = [CoupleMemoryStruct]()
        for item in try fetchRequest.execute() {
            let coupleMemory = CoupleMemoryStruct(imageData: item.imageData, description: item.memoryDescription ?? "", memoryDate: item.memoryDate ?? Date())
            //adds it onto the array
            coupleMemoryTemp.append(coupleMemory)
        }
        return coupleMemoryTemp
    }
}
