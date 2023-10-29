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
    @ObservedObject var albumnViewVM: AlbumViewModel
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
            Button(action: {
                showImagePicker = true
            }) {
                
                if let haveUiImage = albumnImage {
                    Image(uiImage: haveUiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 250, height: 250)
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
            
            
            Text("(Write a short description)")
                .font(.system(size: 20, weight: .semibold))
                .frame(width: UIScreen.main.bounds.width * 0.7, alignment: .topLeading)
                .padding(.top, 260)
        }.sheet(isPresented: $showImagePicker, content: {
            PhotosPicker("Select an image", selection: $selectedImage)
        }).onChange(of: selectedImage) { oldValue, newValue in
            //this will store the images to core data and reload it.
            let coupleMemory = CoupleMemoryStruct(imageData: albumnViewVM.selectedImageBinary, description: "", memoryDate: Date())
            albumnViewVM.saveImage(coupleMemory: coupleMemory)
            //reloads the view model
            albumnViewVM.loadAlbumItems()
        }
    }
}

#Preview {
    AlbumView()
}
