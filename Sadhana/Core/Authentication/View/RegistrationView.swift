import SwiftUI

struct RegistrationView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password  = ""
    @State private var confirmPassword  = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            //Logo
            
            Spacer()
            
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
            .padding(.top, 12)
            
            //Sign Up
            Button {
                Task {
                    try await viewModel.createUser(withEmail: email, password: password, fullname: name)
                }
            } label: {
                HStack {
                    Text("SIGN UP")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(Color(.white))
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemBlue))
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .cornerRadius(10)
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
