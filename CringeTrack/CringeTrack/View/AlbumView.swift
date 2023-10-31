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
    @StateObject var albumViewVM: AlbumViewModel = AlbumViewModel()
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 1)
    @State var showImagePicker: Bool = false
    @State var daysString: String
    @State var endDate: Date //this is a variable that will display the images based until the end date when tapped from the home view.
    @State var imageData: Data?
    @State var onChangeCounter: Int = 0
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 40) {

                ForEach($albumViewVM.albumnData) { $item in
                    if let imageData = item.imageData {
                        if let isImage = UIImage(data: imageData) {
                            ZStackContent(albumnImage: isImage, showImagePicker: $showImagePicker, selectedImage: albumViewVM.selectedImage, onChangeCounter: $onChangeCounter, coupleMemory: item, albumnViewVM: albumViewVM, date: $endDate)
                        }
                    }
                }
                //this is an empty albumn image placeholder that will be used to add a new image.
                ZStackContent(showImagePicker: $showImagePicker, onChangeCounter: $onChangeCounter, albumnViewVM: albumViewVM, date: $endDate)
            }
            .padding()
        }.onAppear {
            //loads it from CoreData to the VM
            albumViewVM.loadAlbumItems(date: endDate)
        }.navigationTitle(daysString).navigationBarTitleDisplayMode(.inline)
    }
}

struct ZStackContent: View {
    @State var albumnImage: UIImage?
    @State var description: String?
    @Binding var showImagePicker: Bool
    @State var selectedImage: PhotosPickerItem?
    @Binding var onChangeCounter: Int
    @State var coupleMemory: CoupleMemoryStruct? //this variable will be an optional one and used only if the details needs to be updated such as removing an image or changing it on the albumn.
    @ObservedObject var albumnViewVM: AlbumViewModel
    @State var showMenu: Bool = false
    @State var showEditAlert: Bool = false
    @State var newDescription = ""
    @Binding var date: Date

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
            if let coupleMemory = coupleMemory {
                Menu {
                    PhotosPicker("Change Photo", selection: $selectedImage)
                    Button("Delete Photo") {
                        Task {
                            albumnViewVM.deleteAlbumItem(id: coupleMemory.id)
                            //reloads the data model
                            albumnViewVM.loadAlbumItems(date: date)
                        }
                        
                        
                    }
                        
                    
                } label: {
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
                    Text("(Write a short description)")
                }
                .font(.system(size: 20, weight: .semibold))
                //.frame(width: UIScreen.main.bounds.width * 0.7, alignment: .topLeading)
                .padding(.top, 260)
                
                // Pencil-shaped Button that allows users to change the description
                Button(action: {
                    showEditAlert = true
                }) {
                    Image("Pencil")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                        .padding(.top, 260)
                        .clipped()
                }
            }
            
            
            Text(description ?? "(Write a short description)")
                .font(.system(size: 20, weight: .semibold))
                .frame(width: UIScreen.main.bounds.width * 0.7, alignment: .topLeading)
                .padding(.top, 260)
        }
        .onChange(of: selectedImage) { oldImage, newImage in
            if let newImage = newImage {
                Task {
                    if let newImageData = try! await albumnViewVM.convertToBinaryData(imageFromPhotoPicker: newImage) {
                        print("Image selection triggered.")
                        //this will update the existing albumn item if the user wants to change an image.
                        if let existingAlbumnItem = coupleMemory {
                            albumnViewVM.updateImage(id: existingAlbumnItem.id)
                        } else {
                            onChangeCounter += 1
                            //this will store the images to core data and reload it.
                            let coupleMemory = CoupleMemoryStruct(id: UUID(), imageData: newImageData, description: "(Write a description)", memoryDate: date)
                            albumnViewVM.saveImage(coupleMemory: coupleMemory)
                            //reloads the view model
                            albumnViewVM.loadAlbumItems(date: date)
                            
                        }
                    }
                }
           }
            
        
         
        
        }.alert("Write your description", isPresented: $showEditAlert) {
            TextField("", text: $newDescription)
            Button("Cancel", action: {
                showEditAlert = false
            })
            Button("Confirm", action: {
                if newDescription.count <= 200 {
                    if let id = coupleMemory?.id {
                        //updates the description on the view side
                        description = newDescription
                        //updates it on the backend.
                        albumnViewVM.updateImageDescription(id: id, imageDescription: newDescription)
                    }
                } else {
                    //displays an alert if charcater count exceeds 200.
                    albumnViewVM.showErrorAlert = true
                    albumnViewVM.alertTitle = "Description is too long"
                    albumnViewVM.alertMessage = "You can only write up to 200 characters for the description."
                }
            })
                

        }.alert(isPresented: $albumnViewVM.showErrorAlert) {
            Alert(
                title: Text(albumnViewVM.alertTitle),
                message: Text(albumnViewVM.alertMessage)
            )
        }
    }
}

#Preview {
    AlbumView(daysString: "7 Days", endDate: Date())
}
