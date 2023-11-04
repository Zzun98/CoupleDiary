//
//  AlbumView.swift
//  CringeTrack
//
//  Created by Sunjun Kwak on 17/10/2023.
//

import SwiftUI
import PhotosUI

struct AlbumView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var albumViewVM: AlbumViewModel
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 1)
    @State var showImagePicker: Bool = false
    @State var daysString: String
    @State var endDate: Date //this is a variable that will display the images based until the end date when tapped from the home view.
    @State var imageData: Data?
    @State var onChangeCounter: Int = 0
    //@State var showEditAlert: Bool = false
    @State var emptyData: Data? = nil //this is a state variable that will pass empty data as a binding.
    @State var placeholderId: UUID = UUID()
    @State var placeHolderDescription: String = "(write a short description)"
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 40) {
                
                ForEach($albumViewVM.albumnData, id: \.self) { $item in
                    Group {
                        ZStackContent(albumnImageData: $item.imageData, description: $item.description, showImagePicker: $showImagePicker, selectedImage: albumViewVM.selectedImage, onChangeCounter: $onChangeCounter, albumId: $item.id, date: $endDate, itemId: item.id)
                    }
                    
                }
                //this is an empty albumn image placeholder that will be used to add a new image.
               
                ZStackContent(albumnImageData: $emptyData, description: $placeHolderDescription, showImagePicker: $showImagePicker,  onChangeCounter: $onChangeCounter, albumId: $placeholderId, date: $endDate)
            }
            .padding()
        }.onAppear {
            //prints the current date
            print(endDate)
            //injects the date into the vm
            albumViewVM.currentDate = endDate
            //loads it from CoreData to the VM
            albumViewVM.loadAlbumItems(date: endDate)
        }.navigationTitle(daysString).navigationBarTitleDisplayMode(.inline)
    }
}

struct ZStackContent: View {
    @Binding var albumnImageData: Data?
    @Binding var description: String
    @Binding var showImagePicker: Bool
    @State var selectedImage: PhotosPickerItem?
    @Binding var onChangeCounter: Int
    @Binding var albumId: UUID //this variable will be an optional one and used only if the details needs to be updated such as removing an image or changing it on the albumn.
    @EnvironmentObject var albumViewVM: AlbumViewModel
    @State var showMenu: Bool = false
    
    @State var newDescription = ""
    @Binding var date: Date
    @State var showEditAlert: Bool = false
    @State var itemId: UUID?
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(Color.white)
                .frame(width: 320, height: 360)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black, lineWidth: 2)
                )
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 280, height: 220)
                .background(Color(red: 0.96, green: 0.49, blue: 0.43))
                .cornerRadius(10)
                .padding(.top, 24)
            
            // Add action to add photo here
            // After uploading photo, add code to change description of each photo
            if let imageData = albumnImageData  {
                VStack {
                    PhotosPicker("Replace", selection: $selectedImage, matching: .images)
                        .font(.system(size: 20, weight: .semibold))
                        .frame(width: 160, height: 40)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(20)
                    
                    Button {
                        Task {
                            albumViewVM.deleteAlbumItem(id: albumId)
                            //reloads the data model
                            albumViewVM.loadAlbumItems(date: date)
                        }
                    } label: {
                        Text("Delete")
                            .font(.system(size: 20, weight: .semibold))
                            .frame(width: 160, height: 40)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(20)
                    }
                }
                
                if let haveUiImage = UIImage(data: imageData) {
                    Image(uiImage: haveUiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .padding(.top, 110)
                        .clipped()
                } else {
                    Image("AddPhoto")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .padding(.top, 110)
                        .clipped()
                }
            } else {
                PhotosPicker(selection: $selectedImage, matching: .images) {
                    Image("AddPhoto")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .padding(.top, 110)
                        .clipped()
                }
            }
            // The text here should change depending on the user's input
            // Up to 200 characters per photo
            HStack {
                Button {
                    
                } label: {
                    Text(description)
                }
                .font(.system(size: 20, weight: .semibold))
                //.frame(width: UIScreen.main.bounds.width * 0.7, alignment: .topLeading)
                .padding(.top, 260)
                
                // Pencil-shaped Button that allows users to change the description
                Button {
                    showEditAlert = true
                } label: {
                    Image("Pencil")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                        .padding(.top, 260)
                        .clipped()
                }
            }.alert("Write your description", isPresented: $showEditAlert) {
                TextField("", text: $newDescription)
                Button("Cancel") {
                    showEditAlert = false
                }
                Button("Confirm") {
                    if newDescription.count <= 200 {
                        if albumnImageData != nil {
                            Task {
                                //updates the description on the view side
                                description = newDescription
                                //updates it on the backend.
                                albumViewVM.updateImageDescription(id: albumId, imageDescription: newDescription)
                            }
                        } else {
                            albumViewVM.showErrorAlert = true
                            albumViewVM.alertTitle = "Unable to add description"
                            albumViewVM.alertMessage = "Please add an image first."
                        }
                        
                    } else {
                        //displays an alert if charcater count exceeds 200.
                        albumViewVM.showErrorAlert = true
                        albumViewVM.alertTitle = "Description is too long"
                        albumViewVM.alertMessage = "You can only write up to 200 characters for the description."
                    }
                }
            }
        }
        
        .onChange(of: selectedImage) { oldImage, newImage in
            if let newImage = newImage {
                Task {
                    do {
                        if let newImageData = try await albumViewVM.convertToBinaryData(imageFromPhotoPicker: newImage) {
                            print("Image selection triggered.")
                            //this will update the existing albumn item if the user wants to change an image.
                            if albumnImageData != nil {
                                Task {
                                    
                                    albumViewVM.updateImage(id: albumId, imageData: newImageData)
                                    //updates it on the view side
                                    albumnImageData = newImageData
                                    //reloads the vm
                                    //albumnViewVM.loadAlbumItems(date: date)
                                }
                                
                            } else {
                                onChangeCounter += 1
                                //this will store the images to core data and reload it.
                                let coupleMemory = CoupleMemoryStruct(id: UUID(), imageData: newImageData, description: "(Write a description)", memoryDate: date)
                                albumViewVM.saveImage(coupleMemory: coupleMemory)
                                //reloads the view model
                                albumViewVM.loadAlbumItems(date: date)
                                
                            }
                        }
                    } catch {
                        albumViewVM.showErrorAlert = true
                        albumViewVM.alertTitle = "Somethng went wrong."
                        albumViewVM.alertMessage = "Unable to update an image."
                    }
                    
                }
            }
        }.alert(isPresented: $albumViewVM.showErrorAlert) {
            Alert(
                title: Text(albumViewVM.alertTitle),
                message: Text(albumViewVM.alertMessage)
            )
        }
    }
}

#Preview {
    AlbumView(daysString: "7 Days", endDate: Date())
}
/*
 if let haveUiImage = albumnImage {
 Image(uiImage: haveUiImage)
 .resizable()
 .aspectRatio(contentMode: .fill)
 .frame(width: 150, height: 150)
 .padding(.top, 110)
 .clipped()
 } else {
 Image("AddPhoto")
 .resizable()
 .aspectRatio(contentMode: .fill)
 .frame(width: 50, height: 50)
 .padding(.top, 110)
 .clipped()
 }
 })*/
