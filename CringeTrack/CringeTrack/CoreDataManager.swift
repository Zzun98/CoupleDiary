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
        for item in try context.fetch(fetchRequest) {
            let coupleMemory = CoupleMemoryStruct(imageData: item.imageData, description: item.memoryDescription ?? "", memoryDate: item.memoryDate ?? Date())
            //adds it onto the array
            coupleMemoryTemp.append(coupleMemory)
        }
        return coupleMemoryTemp
    }
    
    //this is a helper function that will store a partner onto CoreData including their birthdays.
    static private func storePartner(name: String, dateOfBirth: Date, isPrimaryPartner: Bool) throws {
        let newPartner = Partner(context: context)
        newPartner.name = name
        newPartner.dateOfBirth = dateOfBirth
        //this is used to reflect the front end structure so it can be sorted based on primary partner status.
        newPartner.primaryPartner = isPrimaryPartner
        
        //saves it to the Core Data Persistance Context
        try context.save()
    }
    
    //this is a function that will store two partners onto CoreData, also known as a couple.
    static func storePartnerPair(firstPartnersName p1Name: String, firstPartnersDateOfBirth p1Dob: Date, secondPartnersName p2Name: String, secondPartnersDob p2Dob: Date) throws {
        //for the first partner, lets say its a man
        try storePartner(name: p1Name, dateOfBirth: p1Dob, isPrimaryPartner: true)
        //for the second partner, lets say its a woman
        try storePartner(name: p2Name, dateOfBirth: p2Dob, isPrimaryPartner: false)
    }
    
    //the fetch partners will not be listed here as it is responsible for the front end using @FetchRequest.
    
    //this is a function that will store when did they meet.
    static func storeDateMet(dateMet: Date) throws {
        let newDateMet = Onboarding(context: context)
        newDateMet.dateMet = dateMet
        
        //saves it to the context
        try context.save()
    }
    
    //this will fetch the onboarding data including days met
    static func fetchFirstMet() throws -> Date? {
        let fetchRequest: NSFetchRequest<Onboarding> = Onboarding.fetchRequest()
        let fetchResuls = try context.fetch(fetchRequest)
        //this will return the date object if there are data stored.
        //for th;e purpose of this app, since its already synced to cloudKit, each account will have one data stores.
        //in this case, it will only get the first index of date met.
        if let dateMet = fetchResuls.first?.dateMet {
            return dateMet
        } else {
            //this will return nil if there are no records in the results.
            return nil
        }
        
    }
    
    //this function will be called from the reset setting
    //it will clear all CringTrack data in an event of a relationship breakup.
    static func clearEverything() throws {
        //deals with the fetch requests for all entities allocated.
        let onboardingFr: NSFetchRequest<NSFetchRequestResult> = Onboarding.fetchRequest()
        let memoryFr: NSFetchRequest<NSFetchRequestResult> = Memory.fetchRequest()
        let partnersFr: NSFetchRequest<NSFetchRequestResult> = Partner.fetchRequest()
        //puts it on the delte request batch
        let onboardingDeleteRq = NSBatchDeleteRequest(fetchRequest: onboardingFr)
        let memoryDeleteRq = NSBatchDeleteRequest(fetchRequest: memoryFr)
        let partnersDeleteRq = NSBatchDeleteRequest(fetchRequest: partnersFr)
        //processes the delete operation
        try context.execute(onboardingDeleteRq)
        try context.execute(memoryDeleteRq)
        try context.execute(partnersDeleteRq)
    }
}
