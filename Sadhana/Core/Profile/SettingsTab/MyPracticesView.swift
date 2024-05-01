import SwiftUI
import Firebase
import FirebaseFirestore

struct MyPracticesView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    @State private var isNextViewPresented = false
    
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack {
                VStack {
                    ForEach(user.practices) { practice in
                        Button {
                            Task {
                                isNextViewPresented = true
                                await settingsViewModel.fetchPracticeData(practiceID: practice.id)
                            }
                        } label: {
                            SettingsMyPracticeNavigationLink(practiceID: practice.id)
                        }
                        .sheet(isPresented: $isNextViewPresented) {
                            SettingsIndividualPractice()
                        }
                    }
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .navigationTitle("My Practices")
        }
    }
}

struct MyPracticesView_Previews: PreviewProvider {
    static var previews: some View {
        MyPracticesView()
    }
}
