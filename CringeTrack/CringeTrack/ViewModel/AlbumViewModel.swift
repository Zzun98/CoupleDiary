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
    @Published var selectedImage: PhotosPickerItem? = nil {
        didSet {
            do {
                try setImageRawData(imageFromPhotoPicker: selectedImage!)
            } catch {
                print("Failed converting to raw data.")
            }
        }
    }
    //this is a variable that will have the image data from the photopickeritem.
    @Published var selectedImageBinary: Data?
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
            print("Loaded albumn data.")
        } catch {
            print("Failed to load albumns.")
            print(error)
            print(error.localizedDescription)
        }
        
    }
    
    func setImageRawData(imageFromPhotoPicker: PhotosPickerItem) throws {
        Task {
            if let data = try await imageFromPhotoPicker.loadTransferable(type: Data.self) {
                self.selectedImageBinary = data
            }
        }
    }
}
