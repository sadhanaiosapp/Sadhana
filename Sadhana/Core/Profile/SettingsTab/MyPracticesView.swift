import SwiftUI
import Firebase
import FirebaseFirestore

struct MyPracticesView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack {
                VStack {
                    ForEach(user.practices) { practice in
                        NavigationLink {
                            SettingsIndividualPractice(displayText: practice.id)
                        } label: {
                            SettingsMyPracticeNavigationLink(displayText: practice.id)
                        }
                        .padding(.init(top: 0, leading: 20, bottom: 20, trailing: 20))
                    }
                }
                .padding(.top, 20)
                
                Spacer()
            }
        }
    }
}

struct MyPracticesView_Previews: PreviewProvider {
    static var previews: some View {
        MyPracticesView()
    }
}
