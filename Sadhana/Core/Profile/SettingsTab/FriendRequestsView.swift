import SwiftUI
import Firebase
import FirebaseFirestore

struct FriendRequestsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if settingsViewModel.friendRequests.count != 0 {
                ForEach(settingsViewModel.friendRequests) { friendRequest in
                    FriendRequestView(name: friendRequest.fullname, email: friendRequest.email)
                }
            }
            
            else {
                Text("You have no new friend requests.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .refreshable {
            Task {
                let uid = UserDefaults.standard.string(forKey: "user")
                await settingsViewModel.fetchFriendRequests(uid: uid!)
            }
        }
    }
}
