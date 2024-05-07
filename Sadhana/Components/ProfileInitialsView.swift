//
//  ProfileInitialsView.swift
//  Sadhana
//
//  Created by Sadhana on 5/5/24.
//

import SwiftUI

struct ProfileInitialsView: View {
    var initials: String
    var fullname: String
    var email: String
    
    @State private var isNextViewPresented = false
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    var body: some View {
        Button {
            Task {
                await settingsViewModel.fetchFriendProfile(email: email)
            }
            self.isNextViewPresented = true
        } label: {
            HStack {
                Text(initials)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 72, height: 72)
                    .background(Color(.systemGray2))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(fullname)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.top, 4)
                    
                    Text(email)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 32)
            .padding(.top, 10)
        }
        .sheet(isPresented: $isNextViewPresented) {
            FriendProfileView(fullname: fullname, email: email)
        }
    }
}

struct ProfileInitialsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInitialsView(initials: "JP", fullname: "Jayanth Peetla", email: "jpeetla1@gmail.com")
    }
}
