//
//  PartnerRow.swift
//  CringeTrack
//
//  Created by Christopher Averkos on 30/10/2023.
//

import SwiftUI

struct PartnerRow: View {
    @State var partnerName: String
    @State var partnerDob: Date
    @State var isPrimaryPartner: Bool
    @State var partnerNewName: String = ""
    @State var showEditAlert: Bool = false
    let currentDate = Date()
    @EnvironmentObject var coupleDiaryMain: CoupleDiaryMain
    var body: some View {
        VStack {
            HStack {
                Text("\(partnerName)")
                    .font(.system(size: 24, weight: .medium))
                Spacer()
                    .frame(width: 40)
                Button(action: {
                    self.showEditAlert = true
                }) {
                    Image("Pencil")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                        .clipped()
                }
                Spacer()
                
                .padding(.bottom, 10)
                .alert(isPrimaryPartner ? "Write your name" : "Write their name", isPresented: $showEditAlert) {
                     TextField("", text: $partnerNewName)
                     Button("Cancel", action: {})
                     Button("Confirm", action: {})
                }
              
            }

            // Select birthday
            HStack {
                DatePicker("",
                    selection: $partnerDob,
                    in: ...currentDate,
                    displayedComponents: .date
                )
                .labelsHidden()
                .padding(.bottom, 50)
                
                Spacer()
            }
            
        }
    }
}

#Preview {
    PartnerRow(partnerName: "Abbey Donut", partnerDob: Date(), isPrimaryPartner: false)
}
