import SwiftUI
import Firebase
import FirebaseFirestore

struct MyFriendsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        ScrollView() {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(settingsViewModel.friends) { friend in
                    ProfileInitialsView(initials: friend.initials, fullname: friend.fullname, email: friend.email)
                }
            }
            .padding(.top, 20)
            .navigationTitle("My Friends")
        }
        .refreshable {
            Task {
                let uid = UserDefaults.standard.string(forKey: "user")
                await settingsViewModel.fetchMyFriends(uid: uid!)
            }
        }
    }
}

struct MyFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        MyFriendsView()
    }
}
