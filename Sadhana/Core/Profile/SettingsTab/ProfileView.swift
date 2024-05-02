import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack {
                List {
                    //HEADLINE
                    Section {
                        HStack {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray2))
                            .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullname)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                
                                Text(user.email)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                        
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
                            SettingsRowView(imageName: "figure.yoga", title: "My Practices", tintColor: Color(.blue))
                        }
                        
                        NavigationLink {
                            MyFriendsView()
                        } label: {
                            SettingsRowView(imageName: "person.crop.circle.badge.plus", title: "My Friends", tintColor: Color(.blue))
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