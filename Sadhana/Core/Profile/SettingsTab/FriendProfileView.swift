import SwiftUI
import Firebase
import FirebaseFirestore

struct FriendProfileView: View {
    var fullname: String
    var email: String
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if settingsViewModel.friendProfilePractices != [] {
                Text("\(fullname) is practicing")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                ForEach(settingsViewModel.friendProfilePractices, id: \.self) { practice in
                    Text(practice)
                        .font(.headline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                                .foregroundColor(.white)
                        )
                        .foregroundColor(.white)
                        .padding(.vertical, 5)
                }
            }
            
            else {
                Text("\(fullname) is yet to start practicing anything!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Name: \(fullname)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("Email: \(email)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 100)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 5)
        )
        .padding()
    }
}
