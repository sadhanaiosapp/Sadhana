import SwiftUI

struct LogInView: View {
    @State private var email = ""
    @State private var password  = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                //Logo
                Image("TransparentLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                
                //Form Fields
                VStack(spacing: 24) {
                    InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                        .autocapitalization(.none)
                    InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                        .autocapitalization(.none)
                }
                .padding(.horizontal, 15)                
                
                //Sign In Button
                Button {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                } label: {
                    BottomBlueButton(text: "SIGN IN", image: "arrow.right", color: Color(.white), textColor: Color(.systemBlue))
                }
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
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
            .background{
                LinearGradient(gradient: Gradient(colors: [Color(hex: "#79FF92"), Color(hex: "#B0F8FF")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

//form validation
extension LogInView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
