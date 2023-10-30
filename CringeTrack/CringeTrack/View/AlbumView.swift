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
    @State var endDate: Date? //this is a variable that will display the images based until the end date when tapped from the home view.
    @State var imageData: Data?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 40) {

                ForEach($albumViewVM.albumnData) { $item in
                    if let imageData = item.imageData {
                        if let isImage = UIImage(data: imageData) {
                            ZStackContent(albumnImage: isImage, showImagePicker: $showImagePicker, selectedImage: $albumViewVM.selectedImage, albumnViewVM: albumViewVM)
                        }
                    }
                }
                //this is an empty albumn image placeholder that will be used to add a new image.
                ZStackContent(showImagePicker: $showImagePicker, selectedImage: $albumViewVM.selectedImage, albumnViewVM: albumViewVM)
            }
            .padding()
        }.onAppear {
            //loads it from CoreData to the VM
            albumViewVM.loadAlbumItems()
        }
    }
}

struct ZStackContent: View {
    @State var albumnImage: UIImage?
    @State var description: String?
    @Binding var showImagePicker: Bool
    @Binding var selectedImage: PhotosPickerItem?
    @State var coupleMemory: CoupleMemoryStruct? //this variable will be an optional one and used only if the details needs to be updated such as removing an image or changing it on the albumn.
    @ObservedObject var albumnViewVM: AlbumViewModel
    @State var onChangeCounter: Int = 0
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
            
            PhotosPicker(selection: $selectedImage, matching: .images) {
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
                
            }.onChange(of: selectedImage) { oldImage, newImage in
                //if (newImage != nil) || (oldImage == nil && newImage != nil) {
                
                if newImage != oldImage {
                    onChangeCounter = 0
                }
                
                if onChangeCounter == 0 {
                    if let newImage = newImage {
                        Task {
                            if let newImageData = try! await albumnViewVM.convertToBinaryData(imageFromPhotoPicker: newImage) {
                                print("Image selection triggered.")
                                //this will update the existing albumn item if the user wants to change an image.
                                if let existingAlbumnItem = coupleMemory {
                                    albumnViewVM.updateImage(id: existingAlbumnItem.id)
                                } else {
                                    //this will store the images to core data and reload it.
                                    let coupleMemory = CoupleMemoryStruct(id: UUID(), imageData: newImageData, description: "(Write a description)", memoryDate: Date())
                                    albumnViewVM.saveImage(coupleMemory: coupleMemory)
                                    //reloads the view model
                                    albumnViewVM.loadAlbumItems()
                                    onChangeCounter += 1
                                    return
                                }
                            }
                           
                           
                        }
                        
                        
                    
                }
                
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
                    
                }) {
                    Image("Pencil")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                        .padding(.top, 260)
                        .clipped()
                }
            }
            
            
            Text("(Write a short description)")
                .font(.system(size: 20, weight: .semibold))
                .frame(width: UIScreen.main.bounds.width * 0.7, alignment: .topLeading)
                .padding(.top, 260)
        }
    }
}

#Preview {
    AlbumView()
}
