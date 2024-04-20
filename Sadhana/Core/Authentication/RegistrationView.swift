import SwiftUI

struct RegistrationView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password  = ""
    @State private var confirmPassword  = ""
    @Environment(\.dismiss) var dismiss
    
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
                InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Re-enter your password", isSecureField: true)
                    .autocapitalization(.none)
            }
            .padding(.horizontal, 15)
            .padding(.top, 12)
            
            //Sign Up
            Button {
                print("Creating user account...")
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

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
