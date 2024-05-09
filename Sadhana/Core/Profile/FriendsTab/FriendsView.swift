import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var friendsViewModel: FriendsViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                Text("")
                ForEach(friendsViewModel.posts) { post in
                    PostView(statement: post.statement, date: post.date, user: post.user)
                }
            }
            .refreshable {
                //Refresh User Data
                Task {
                    let uid = UserDefaults.standard.string(forKey: "user")
                    await friendsViewModel.fetchPosts(uid: uid!)
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
            
            NavigationLink {
                CreateNewPostView()
            } label: {
                BottomBlueButton(text: "New Post", image: "plus.circle", color: Color(.systemBlue), textColor: Color(.white))
            }
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
