//
//  Persistence.swift
//  CringeTrack
//
//  Created by Christopher Averkos on 22/10/2023.
//

//import Foundation
import CoreData
import CloudKit

struct PersistenceController {
    static let shared = PersistenceController()
    /*
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()*/

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        //this is used to determine if cloudKit is enabled or not
        //if another computer does not have cloudKit enabled, it will use the internal CoreData persistance where it would only store locally on the user's device.
        #if(canImport(CloudKit))
        container = NSPersistentCloudKitContainer(name: "CringeTrack")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        /*
        //these are seperate store descriptions for use in CloudKit and local CoreData.
        //stores local store descriptions
        let localStoreLocation                  = URL(fileURLWithPath: "/path/to/local.store")
        let localStoreDescription               = NSPersistentStoreDescription(url: localStoreLocation)
        localStoreDescription.configuration     = "Local"
        
        //this is for the cloud kit local store
        let cloudKitStoreLocation                = URL(fileURLWithPath: "/path/to/cloud.store")
        let cloudKitStoreDescription             = NSPersistentStoreDescription(url: cloudKitStoreLocation)
        cloudKitStoreDescription.configuration   = "Cloud"
        
        //allocates the cloudkit container
        cloudKitStoreDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "UTS.edu.au.CringeTrack")
        //updates container list
        container.persistentStoreDescriptions = [
            cloudKitStoreDescription,
            localStoreDescription
         ]*/
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        #else
        container = NSPersistentContainer(name: "CoreDataDemo")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        #endif
    }
}
