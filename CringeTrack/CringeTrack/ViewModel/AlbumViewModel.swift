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
    @Published var albumnData = [CoupleMemoryStruct]()
    
    //this function will process uploading the image from the image picker to CoreData
    func saveImage(coupleMemory: CoupleMemoryStruct) {
        do {
           try CoreDataManager.saveMemory(coupleMemory: coupleMemory)
        } catch {
            print("Unable to save image.")
        }
    }
    //this function will fetch it from core data and store it in memory, this will not decode an image as it is done from the frontend.
    func loadAlbumItems() {
        do {
            self.albumnData = try CoreDataManager.loadAlbumns()
        } catch {
            print("Failed to load albumns.")
        }
        
    }
}
