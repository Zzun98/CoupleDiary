//
//  CoupleMemory.swift
//  CoupleDiary
//
//  Created by Christopher Averkos on 17/10/2023.
//

import Foundation
import SwiftUI


//this is a struct that will store a photo and a discription
struct CoupleMemoryStruct: Identifiable {
    var id: UUID = UUID()
    var imageData: Data?
    var description: String
    var memoryDate: Date
    
    //this will be a customized init that will automatically convert the image data to binary so it can be stored to CoreData
    init(uiImage: UIImage?, description: String, memoryDate: Date) throws {
        guard let haveImage = uiImage, let imageData = haveImage.jpegData(compressionQuality: 0.1) else {
            throw TransferError.importFailed
        }
        self.description = description
        self.memoryDate = memoryDate
        self.imageData = imageData
    }
    
    // this is another init that will be used during the fetch request from CoreData.
    init(imageData: Data?, description: String, memoryDate: Date) {
        self.description = description
        self.memoryDate = memoryDate
        self.imageData = imageData
    }
}
