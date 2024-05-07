import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack {
                List {
                    //HEADLINE
                    Section {
                        ProfileInitialsView(initials: user.initials, fullname: user.fullname, email: user.email)
                        
                    }
                    
                    //GENERAL
                    Section("General") {
                        HStack {
                            SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
                            Spacer()
                            Text("1.0.0")
                                .font(.subheadline)
                                .foregroundColor(Color(.systemGray))
                        }
                        
                    }
                    
                    //PROFILE
                    Section("Profile") {
                        NavigationLink {
                            MyPracticesView()
                        } label: {
                            SettingsRowView(imageName: "figure.yoga", title: "My Practices", tintColor: Color(.systemBlue))
                        }
                        
                        NavigationLink {
                            MyFriendsView()
                        } label: {
                            SettingsRowView(imageName: "person.crop.circle.badge.plus", title: "My Friends", tintColor: Color(.systemBlue))
                        }
                    }
                    
                    //ACCOUNT
                    Section("Account") {
                        Button {
                            viewModel.signOut()
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: Color(.red))
                        }
                        
                        Button {
                            print("Deleting account...")
                        } label: {
                            SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: Color(.red))
                        }
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
