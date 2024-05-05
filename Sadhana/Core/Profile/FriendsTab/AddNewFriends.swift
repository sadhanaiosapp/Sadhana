import SwiftUI
import Firebase
import FirebaseFirestore

struct AddNewFriends: View {
    @State private var email = ""
    @State private var showError = ""
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
                        showError = await friendsViewModel.addFriend(uid: user.id, email: email)
                    }
                    
                    if showError != "" {
                        dismiss()
                    }
                } label: {
                    BottomBlueButton(text: "Add Friend", image: "plus.circle.fill")
                }
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .padding(.horizontal)
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
