import SwiftUI

struct RegistrationView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password  = ""
    @State private var confirmPassword  = ""
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var calendarViewModel: CalendarViewModel
    @EnvironmentObject var friendsViewModel: FriendsViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                //Logo
                Image("TransparentLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(10)
                
                //Form Fields
                VStack(spacing: 24) {
                    InputView(text: $name, title: "Full Name", placeholder: "Enter your name")
                    InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                        .autocapitalization(.none)
                    
                    InputView(text: $password, title: "Password", placeholder: "Min. of 6 Characters", isSecureField: true)
                        .autocapitalization(.none)
                    
                    ZStack(alignment: .trailing){
                        InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Re-enter your password", isSecureField: true)
                            .autocapitalization(.none)
                        
                        if(!password.isEmpty && !confirmPassword.isEmpty) {
                            if(password == confirmPassword) {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGreen))
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemRed))
                            }
                        }
                    }
                    
                }
                .padding(.horizontal, 15)
                
                //Sign Up
                Button {
                    Task {
                        try await viewModel.createUser(withEmail: email, password: password, fullname: name)
                        
                        let uid = UserDefaults.standard.string(forKey: "user")
                        await calendarViewModel.fetchDates()
                        await friendsViewModel.fetchPosts(uid: uid!)
                        await settingsViewModel.fetchMyFriends(uid: uid!)
                    }
                } label: {
                    BottomBlueButton(text: "SIGN UP", image: "arrow.right", color: Color(.white), textColor: Color(.systemBlue))
                }
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .padding(.top, 30)
                
                Spacer()
                
                //Return to Log In
                Button {
                    dismiss()
                } label : {
                    Text("Already have an account?")
                        .foregroundColor(Color(.black))
                    Text("Sign in")
                        .fontWeight(.semibold)
                }
            }
        }
        .background{
            LinearGradient(gradient: Gradient(colors: [Color(hex: "#79FF92"), Color(hex: "#B0F8FF")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

//form validation
extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && password == confirmPassword
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
