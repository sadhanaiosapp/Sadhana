import SwiftUI

struct LogInView: View {
    @State private var email = ""
    @State private var password  = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                //Logo
                
                Spacer()
                
                //Form Fields
                VStack(spacing: 24) {
                    InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                        .autocapitalization(.none)
                    InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                        .autocapitalization(.none)
                }
                .padding(.horizontal, 15)
                .padding(.top, 12)
    
                
                //Sign In Button
                Button {
                    print("Logging in user...")
                } label: {
                    HStack {
                        Text("SIGN IN")
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
                
                //Sign Up Button
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(Color(.black))
                        Text("Sign up")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
