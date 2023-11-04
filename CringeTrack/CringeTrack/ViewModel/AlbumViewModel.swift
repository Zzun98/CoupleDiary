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
    @Published var currentDate: Date = Date()
    
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
        
             CoreDataManager.loadAlbumns(date: date)
            .done {
                memories in
                self.albumnData = memories
                print("Loaded albumn data.")
            } .catch {
                error in
                
                print("There are \(self.albumnData.count) memories")
            
                print("Failed to load albumns.")
                print(error)
                print(error.localizedDescription)
            }
            
        
        
    }
    
    func updateImage(id: UUID, imageData: Data) {
        
        //updates it on the Core Data persistance
        CoreDataManager.updateMemory(id: id, imageData: imageData, description: nil)
            .catch { error in
                self.showErrorAlert = true
                self.alertTitle = "An error has occurred"
                self.alertMessage = "Unable to update the image."
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
        
        CoreDataManager.updateMemory(id: id, imageData: nil, description: imageDescription)
            .catch { error in
                self.showErrorAlert = true
                self.alertTitle = "An error has occurred."
                self.alertMessage = "Unable to update image description."
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
