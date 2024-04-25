import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false) {
                    
                }
                .refreshable {
                    //MARK; Refresh User Data
                    
                }
                .navigationTitle("My Profile")
                .toolbar { }
            }
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
