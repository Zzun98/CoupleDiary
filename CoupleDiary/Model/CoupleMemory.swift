//
//  CoupleMemory.swift
//  CoupleDiary
//
//  Created by Christopher Averkos on 17/10/2023.
//

import Foundation

//this is a struct that will store a photo and a discription
struct CoupleMemory: Identifiable {
    var id: UUID = UUID()
    var image: CoupleImage
    var description: String
    var memoryDate: Date
}
//this is a struct where the images will be stored
struct CoupleImage {
    var imageData: Data
}
