import SwiftUI
import Firebase
import FirebaseFirestore

struct CreateNewPostView: View {
    @State private var postText = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var friendsViewModel: FriendsViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            VStack(alignment: .center, spacing: 20) {
                Text("New Post")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding(.bottom, 10)
                
                TextEditor(text: $postText)
                    .frame(height: 150)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                Spacer()
                
                Button(action: {
                    Task {
                        await friendsViewModel.postSadhanaUpdate(isDone: true, time: Timestamp.init(), uid: user.id, email: user.email, statement: postText)
                    }
                    
                    dismiss()
                }) {
                    BottomBlueButton(text: "Post", image: "arrowshape.turn.up.right.fill")
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}


struct CreateNewPostView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewPostView()
    }
}
