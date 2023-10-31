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
    @Published var selectedImage: PhotosPickerItem? = nil /* {
        didSet {
            do {
                try setImageRawData(imageFromPhotoPicker: selectedImage!)
            } catch {
                print("Failed converting to raw data.")
            }
        }
    }*/
    //this is a variable that will have the image data from the photopickeritem.
    @Published var selectedImageBinary: Data?
    @Published var showErrorAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    //this function will process uploading the image from the image picker to CoreData
    func saveImage(coupleMemory: CoupleMemoryStruct) {
        do {
           try CoreDataManager.saveMemory(coupleMemory: coupleMemory)
        } catch {
            showErrorAlert = true
            alertTitle = "An error has occurred"
            alertMessage = "We are unable to save your image onto the app."
            print("Unable to save image.")
            //used for debugging.
            print(error)
            print(error.localizedDescription)
        }
    }
    //this function will fetch it from core data and store it in memory, this will not decode an image as it is done from the frontend.
    @MainActor
    func loadAlbumItems(date: Date) {
        do {
            self.albumnData = try CoreDataManager.loadAlbumns(date: date)
            print("Loaded albumn data.")
            print("There are \(self.albumnData.count) memories")
        } catch {
            print("Failed to load albumns.")
            print(error)
            print(error.localizedDescription)
        }
        
    }
    
    func updateImage(id: UUID) {
        do {
            //updates it on the Core Data persistance
            try CoreDataManager.updateMemory(id: id, imageData: selectedImageBinary, description: nil)
        } catch {
            showErrorAlert = true
            alertTitle = "An error has occurred"
            alertMessage = "Unable to update the image."
        }
    }
    
    func deleteAlbumItem(id: UUID) {
        //deletes it from CoreData
        do {
            try CoreDataManager.deleteMemory(memoryId: id)
        } catch {
            showErrorAlert = true
            alertTitle = "An error has occurred"
            alertMessage = "Unable to delete alumn item."
        }
        
    }
    
    //this is a seperate function to update the image description and store it in CoreData.
    func updateImageDescription(id: UUID, imageDescription: String) {
        do {
            try CoreDataManager.updateMemory(id: id, imageData: nil, description: imageDescription)
        } catch {
            showErrorAlert = true
            alertTitle = "An error has occurred."
            alertMessage = "Unable to update image description."
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
    
    func convertToBinaryData(imageFromPhotoPicker: PhotosPickerItem) async throws -> Data? {
        
        //var convertedToData: Data?
        if let data = try await imageFromPhotoPicker.loadTransferable(type: Data.self) {
            return data
        } else {
            return nil
        }
        
    }
}
