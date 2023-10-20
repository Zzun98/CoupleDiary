//
//  CoupleImage.swift
//  CoupleDiary
//
//  Created by Christopher Averkos on 17/10/2023.
//

import Foundation
import SwiftUI
import PhotosUI
import CoreTransferable
//this is a struct where the images will be stored

enum TransferError: Error {
    case importFailed
}

struct CoupleImage: Transferable {
    let image: Image
    
    static var transferRepresentation: some TransferRepresentation {
        //handles the import and export process of images
        
        DataRepresentation(importedContentType: .image) {
            data in
            #if canImport(UIKit)
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                //allocates the image on this struct
                let image = Image(uiImage: uiImage)
                return CoupleImage(image: image)
            #else
                throw TransferError.importFailed
            #endif
        }
    }
}
