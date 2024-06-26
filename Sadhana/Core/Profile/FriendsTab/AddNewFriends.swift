import SwiftUI
import Firebase
import FirebaseFirestore

struct AddNewFriends: View {
    @State private var email = ""
    @State private var showError = ""
    @State private var isFriendRequestSent = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var friendsViewModel: FriendsViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            VStack(alignment: .center, spacing: 20) {
                Text("Add New Friends")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding(.bottom, 10)
                
                TextField("Enter email address", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .foregroundColor(.black)
                    .disableAutocorrection(true)
                
                if showError != "" {
                    Text(showError)
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                Button{
                    Task {
                        showError = await friendsViewModel.createFriendRequest(uid: user.id, friendRequestEmail: email)
                    }
                    
                    if showError == "" {
                        self.isFriendRequestSent = true
                        dismiss()
                    }
                    
                } label: {
                    BottomBlueButton(text: "Add Friend", image: "plus.circle.fill", color: Color(.systemBlue), textColor: Color(.white))
                }
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .padding(.horizontal)
                .alert(isPresented: $isFriendRequestSent) {
                    Alert(title: Text("Friend Request Sent"), message: Text("Once the user accepts your friend request, you both will become friends!"), dismissButton: .default(Text("Dismiss")))
                }
            }
            .padding()
        }
    }
}

extension AddNewFriends: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
    }
}

struct AddNewFriends_Previews: PreviewProvider {
    static var previews: some View {
        AddNewFriends()
    }
}
