import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var friendsViewModel: FriendsViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(friendsViewModel.posts) { post in
                        PostView(statement: post.statement, date: post.date, user: post.user)
                    }
                }
                .refreshable {
                    //Refresh User Data
                    Task {
                        await friendsViewModel.fetchPosts()
                    }
                }
                .navigationTitle("My Friends")
                .toolbar {
                    Menu {
                        NavigationLink { //Add New Friends
                            AddNewFriends()
                        } label: {
                            Label("Add New Friends", systemImage: "person.badge.plus")
                        }
                        
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                
                Button {
                    
                } label: {
                    BottomBlueButton(text: "New Post", image: "plus.circle")
                }
            }
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
