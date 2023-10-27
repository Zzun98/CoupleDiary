//
//  Memory+CoreDataProperties.swift
//  CringeTrack
//
//  Created by Christopher Averkos on 25/10/2023.
//
//

import Foundation
import CoreData


extension Memory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memory> {
        return NSFetchRequest<Memory>(entityName: "Memory")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var imageName: String?
    @NSManaged public var memoryDate: Date?
    @NSManaged public var memoryDescription: String?

}

extension Memory : Identifiable {

}