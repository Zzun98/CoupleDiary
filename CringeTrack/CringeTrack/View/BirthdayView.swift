//
//  BirthdayView.swift
//  CringeTrack
//
//  Created by Sunjun Kwak on 19/10/2023.
//

import SwiftUI

struct BirthdayView: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var coupleDiaryMain: CoupleDiaryMain
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
            //this is a for each loop that will loop the two partners from CoreData,
            //I have moved the front end code to a different view so it can connect to the backend.
            ForEach(partners) { partner in
                PartnerRow(partnerName: partner.name ?? "", partnerDob: partner.dateOfBirth ?? Date(), isPrimaryPartner: partner.primaryPartner)
                
            }
            
            // Show birthdays at home
            HStack {
                Toggle(isOn: $coupleDiaryMain.showBirthdayOnHomeView) {
                    
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
