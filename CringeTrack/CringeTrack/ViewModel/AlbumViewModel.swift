//
//  AlbumViewModel.swift
//  CringeTrack
//
//  Created by Christopher Averkos on 24/10/2023.
//

//this is a seperate view model to handle a thumbmail of images
import Foundation
import SwiftUI
import PhotosUI

class AlbumViewModel: ObservableObject {
    
    
    //@Published var album: Dictionary
    
    //this function will process uploading the image from the image picker to CoreData
    func saveImage(coupleMemory: CoupleMemoryStruct, uploadedImage: UIImage) {
        do {
           try CoreDataManager.saveMemory(coupleMemory: coupleMemory, coupleUiImage: uploadedImage)
        } catch {
            print("Unable to save image.")
        }
    }
}
