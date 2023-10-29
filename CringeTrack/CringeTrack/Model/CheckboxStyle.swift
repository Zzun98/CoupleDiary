//
//  CheckboxStyle.swift
//  CringeTrack
//
//  Created by Sunjun Kwak on 20/10/2023.
//

// Code file for checkbox toggle style

import Foundation
import SwiftUI

struct CheckboxStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Image(systemName: "checkmark.square")
                .symbolVariant(configuration.isOn ? .fill : .none)
        }
    }
    
}
