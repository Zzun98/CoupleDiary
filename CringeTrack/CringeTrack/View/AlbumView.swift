//
//  AlbumView.swift
//  CringeTrack
//
//  Created by Sunjun Kwak on 17/10/2023.
//

import SwiftUI
import PhotosUI

struct AlbumView: View {
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 1)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 40) {
                ForEach(0..<6) { _ in
                    ZStackContent()
                }
            }
            .padding()
        }
    }
}

struct ZStackContent: View {
    
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
            Button(action: {
                
            }) {
                Image("AddPhoto")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .padding(.top, 110)
                    .clipped()
            }
            
            // The text here should change depending on the user's input
            // Up to 200 characters per photo
            HStack {
                Text("(Write a short description)")
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
            
            
        }
    }
}

#Preview {
    AlbumView()
}
