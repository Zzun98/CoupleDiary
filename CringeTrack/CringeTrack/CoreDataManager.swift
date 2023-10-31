//
//  CoreDataManager.swift
//  CringeTrack
//
//  Created by Christopher Averkos on 22/10/2023.
//

import Foundation
import SwiftUI
import CoreData

enum QueryError: Error {
    case noRecords(message: String)
}

class CoreDataManager {
    static let context = PersistenceController.shared.container.viewContext
    
    //this will store a memory onto the CoreData after the user adds a photo and description
    static func saveMemory(coupleMemory: CoupleMemoryStruct) throws {
        let newMemory = Memory(context: context)
        newMemory.id = coupleMemory.id
        newMemory.imageData = coupleMemory.imageData
        newMemory.memoryDate = coupleMemory.memoryDate
        newMemory.memoryDescription = coupleMemory.description
        
        //saves it to the database
        try context.save()
    }
    
    //this will be used to about a couple memory item which is the albumn image with the description.
    //the dates will not be updated as it is fixed on that particular view.
    static func updateMemory(id: UUID, imageData: Data?, description: String?) throws {
        let fetchRequest: NSFetchRequest<Memory> = Memory.fetchRequest()
        let specificMemoryPred: NSPredicate = NSPredicate(format: "id == %@", id.uuidString)
        fetchRequest.predicate = specificMemoryPred
        let memoryItem = try context.fetch(fetchRequest).first
        //this will only update the image data if the user intentially changes it.
        if let imageData = imageData {
            memoryItem?.imageData = imageData
        }
        if let description = description {
            memoryItem?.memoryDescription = description
        }
        //saves it to the context
        try context.save()
    }
    
    //this will only load data from CoreData and will not automatically convert it to an image as it is done from the frontend.
    static func loadAlbumns() throws -> [CoupleMemoryStruct] {
        let fetchRequest: NSFetchRequest<Memory> = Memory.fetchRequest()
        var coupleMemoryTemp = [CoupleMemoryStruct]()
        for item in try context.fetch(fetchRequest) {
            let coupleMemory = CoupleMemoryStruct(id: item.id, imageData: item.imageData, description: item.memoryDescription ?? "", memoryDate: item.memoryDate ?? Date())
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
    
    //this is a function that will delete a specific albumn item
    static func deleteMemory(memoryId id: UUID) throws {
        let fetchRequest: NSFetchRequest = Memory.fetchRequest()
        let memoryIdPred: NSPredicate = NSPredicate(format: "id == %@", id.uuidString)
        fetchRequest.predicate = memoryIdPred
        if let result = try context.fetch(fetchRequest).first {
            context.delete(result)
        } else {
            throw QueryError.noRecords(message: "Particular albumn item does not match with it's id.")
        }
        //updates the context
        try context.save()
    }
    
    //this is a function to update partner's details including their name and birtday
    static func updatePartner(name: String, birthday: Date, isPrimaryPartner: Bool) throws {
        let fetchRequest: NSFetchRequest<Partner> = Partner.fetchRequest()
        let partnerPred: NSPredicate = NSPredicate(format: "primaryPartner == %@", NSNumber(value: isPrimaryPartner))
        //allocates the predicate to the fetchRequest
        fetchRequest.predicate = partnerPred
        let results = try context.fetch(fetchRequest)
        guard let partnerResult = results.first else {
            throw QueryError.noRecords(message: "The selected partner was not found.")
        }
        //updates the partner details
        partnerResult.name = name
        partnerResult.dateOfBirth = birthday
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
