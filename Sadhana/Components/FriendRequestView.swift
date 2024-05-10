//
//  FriendRequestView.swift
//  Sadhana
//
//  Created by Sadhana on 5/10/24.
//

import SwiftUI

struct FriendRequestView: View {
    let name: String
    let email: String
    @EnvironmentObject var friendsViewModel: FriendsViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                Text(email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            HStack(spacing: 20) {
                Button(action: {
                    // Action for declining friend request
                    Task {
                        let uid = UserDefaults.standard.string(forKey: "user")
                        await friendsViewModel.removeFriendRequest(uid: uid!, friendRequestEmail: email)
                        await settingsViewModel.fetchFriendRequests(uid: uid!)
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    // Action for accepting friend request
                    Task {
                        let uid = UserDefaults.standard.string(forKey: "user")
                        await friendsViewModel.addFriend(uid: uid!, friendRequestEmail: email)
                        await settingsViewModel.fetchFriendRequests(uid: uid!)
                    }
                }) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

struct FriendRequestView_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestView(name: "John Doe", email: "john.doe@example.com")
            .previewLayout(.sizeThatFits)
    }
}
