//
//  BirthdayView.swift
//  CringeTrack
//
//  Created by Sunjun Kwak on 19/10/2023.
//

import SwiftUI

struct BirthdayView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Partner.primaryPartner, ascending: false)],
        animation: .default)
    private var partners: FetchedResults<Partner>
    @State private var birthdayOn = false
    @State private var selectedDate = Date()
    @State private var myName = false
    @State private var myNameInput = ""
    @State private var theirName = false
    @State private var theirNameInput = ""
    let currentDate = Date()
    
    var body: some View {
        VStack() {
            HStack {
                Text("Birthdays")
                    .font(.system(size: 32, weight: .bold))
                Spacer()
            }
            .padding(.bottom, 40)
            
            ForEach(partners) { partner in
                PartnerRow(partnerName: partner.name ?? "", partnerDob: partner.dateOfBirth ?? Date(), isPrimaryPartner: partner.primaryPartner)
                
            }
            
            /*
            // Edit 'my' name
            HStack {
                Text("My Name")
                    .font(.system(size: 24, weight: .medium))
                Spacer()
                    .frame(width: 40)
                Button(action: {
                    self.myName = true
                }) {
                    Image("Pencil")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                        .clipped()
                }
                Spacer()
            }
            .padding(.bottom, 10)
            .alert("Write your name", isPresented: $myName) {
                 TextField("", text: $myNameInput)
                 Button("Cancel", action: {})
                 Button("Confirm", action: {})
            }
            
            // Select 'my' birthday
            HStack {
                DatePicker("",
                    selection: $selectedDate,
                    in: ...currentDate,
                    displayedComponents: .date
                )
                .labelsHidden()
                .padding(.bottom, 50)
                
                Spacer()
            }
            
            // Edit 'their' name
            HStack {
                Text("Their Name")
                    .font(.system(size: 24, weight: .medium))
                Spacer()
                    .frame(width: 40)
                Button(action: {
                    self.theirName = true
                }) {
                    Image("Pencil")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                        .clipped()
                }
                Spacer()
            }
            .padding(.bottom, 10)
            .alert("Write their name", isPresented: $theirName) {
                 TextField("", text: $theirNameInput)
                 Button("Cancel", action: {})
                 Button("Confirm", action: {})
            }
            
            // Birthday picker for 'their' birthday
            HStack {
                DatePicker("",
                    selection: $selectedDate,
                    in: ...currentDate,
                    displayedComponents: .date
                )
                .labelsHidden()
                .padding(.bottom, 50)
                
                Spacer()
            }*/
            
            // Show birthdays at home
            HStack {
                Toggle(isOn: $birthdayOn) {
                    
                }
                .toggleStyle(CheckboxStyle())
                Text("Show birthdays at home")
                    .font(.system(size: 24, weight: .medium))
                Spacer()
            }
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    BirthdayView()
}
