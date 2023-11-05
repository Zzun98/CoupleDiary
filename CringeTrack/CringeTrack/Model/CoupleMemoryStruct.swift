//
//  CoupleMemory.swift
//  CoupleDiary
//
//  Created by Christopher Averkos on 17/10/2023.
//

import Foundation
import SwiftUI


//this is a struct that will store a photo and a discription
struct CoupleMemoryStruct: Identifiable, Hashable{
    var id: UUID
    var imageData: Data?
    var description: String
    var memoryDate: Date
    
    // this is another init that will be used during the fetch request from CoreData.
    init(id: UUID, imageData: Data?, description: String, memoryDate: Date) {
        self.id = id
        self.description = description
        self.memoryDate = memoryDate
        self.imageData = imageData
    }
}
