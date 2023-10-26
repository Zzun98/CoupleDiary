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
    
    //this is a helper function that will store a partner onto CoreData including their birthdays.
    static private func storePartner(name: String, dateOfBirth: Date) throws {
        let newPartner = Partner(context: context)
        newPartner.name = name
        newPartner.dateOfBirth = dateOfBirth
        
        //saves it to the Core Data Persistance Context
        try context.save()
    }
    
    //this is a function that will store two partners onto CoreData, also known as a couple.
    static func storePartnerPair(firstPartnersName p1Name: String, firstPartnersDateOfBirth p1Dob: Date, secondPartnersName p2Name: String, secondPartnersDob p2Dob: Date) throws {
        //for the first partner, lets say its a man
        try storePartner(name: p1Name, dateOfBirth: p1Dob)
        //for the second partner, lets say its a woman
        try storePartner(name: p2Name, dateOfBirth: p2Dob)
    }
    
    //the fetch partners will not be listed here as it is responsible for the front end using @FetchRequest.
    
    //this is a function that will store when did they meet.
    static func storeDateMet(dateMet: Date) throws {
        let newDateMet = Onboarding(context: context)
        newDateMet.dateMet = dateMet
        
        //saves it to the context
        try context.save()
    }
}
