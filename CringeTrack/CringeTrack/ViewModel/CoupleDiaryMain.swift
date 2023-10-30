//
//  CoupleDiaryMain.swift
//  CoupleDiary
//
//  Created by Christopher Averkos on 17/10/2023.
//

import Foundation

import PhotosUI
import CoreTransferable
import SwiftUI

//this is a state for the images being displayed to detriermine if it is uploaded correctlh
enum ImageState {
    case empty
    case sucess(Image?)
    case loading(Progress)
    case failuer(Error)
}

//this is the main view model that will store all stuffs for couple dairy including photos.
class CoupleDiaryMain: ObservableObject {
    @Published var showErrorAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var isSetup: Bool = false //this is a boolean that will determine if the user is already used the app before or using it for the first time.
    @Published var currentImageState: ImageState = .empty
    @Published var dateMet: Date = Date()
    //calculates the total days they have met.
    var totalDaysMet: Int {
        let calendar = Calendar.current
        let dateComp = calendar.dateComponents([.day], from: dateMet, to: Date())
        //returns the calculated days.
        return dateComp.day ?? 0
    }
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            //checks if selected.
            if let imageSelection {
               let progress = loadTransferable(from: imageSelection)
            }
        }
    }
    
    
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: CoupleImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("failed to get selected item")
                    return
                }
                
                switch result {
                case .success(let cImage?):
                    self.currentImageState = .sucess(cImage.image)
                case .success(nil):
                    self.currentImageState = .empty
                case .failure(let error):
                    self.currentImageState = .failuer(error)
                }
            }
        }
    }
    
    //this will save the date met onto CoreData
    func processOnboarding() {
        do {
            try CoreDataManager.storeDateMet(dateMet: dateMet)
            //this will create blank instance of partners, the partners name can be set later.
            try CoreDataManager.storePartnerPair(firstPartnersName: "My Name", firstPartnersDateOfBirth: Date(), secondPartnersName: "Their Name", secondPartnersDob: Date())
            //changes it to in session tab view.
            self.isSetup = true
        } catch {
            print("Unable to process onboarding \(error.localizedDescription)")
            print(error)
        }
     
    }
    
    //this is za function that will load the onboarding data from CoreData
    func loadOnboarding() {
        do {
            if let dateMetStored = try CoreDataManager.fetchFirstMet() {
                self.dateMet = dateMetStored
                print("Successfully loaded date met")
            } else {
                print("You do not have date met stored on the database.")
            }
        } catch {
            print("Error fetching data.d")
            print(error)
            print(error.localizedDescription)
        }
    }
    
    
    //this function will be used when the app starts to check if there is data stored or not.
    //if there is no data stored in CoreData, it will show the logo view where the user have to go through the onboarding process.
    func isConfigured() {
        do {
            if try CoreDataManager.fetchFirstMet() != nil {
                self.isSetup = true
            }
        } catch {
            print("Error fetching data.")
        }
    }
    
    //this is a function that will update the partner's details
    func updatePartner(partnerNewName: String, partnerBirthday: Date, isPrimaryPartner: Bool) {
        do {
            try CoreDataManager.updatePartner(name: partnerNewName, birthday: partnerBirthday, isPrimaryPartner: isPrimaryPartner)
        } catch {
            showErrorAlert = true
            alertTitle = "An Error has occurred!"
            alertMessage = "Unable to update name or birthday."
            print(error)
            print(error.localizedDescription)
        }
    }
    
}
