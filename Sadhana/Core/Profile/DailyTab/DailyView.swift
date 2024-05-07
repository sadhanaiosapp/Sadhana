import SwiftUI
import Firebase
import FirebaseFirestore

struct DailyView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack {
                ScrollView {
                    VStack() {
                        ForEach(user.practices.indices, id: \.self) { index in
                            ToDoListItemView(item: user.practices[index], index: index)
                                .padding(.horizontal)
                        }
                    }
                }
                .navigationTitle("Daily Sadhana")
                .toolbar(content:  {
                    Menu {
                        NavigationLink { //Add New Sadhana Button
                            NewSadhanaView()
                        } label: {
                            Label("New Daily Sadhana", systemImage: "figure.yoga")
                        }
                        
                        NavigationLink { //Start New Mandala Button
                            NewMandalaView()
                        } label: {
                            Label("Start New Mandala", systemImage: "plus")
                        }
                        
                    } label: {
                        Image(systemName: "plus")
                    }
                })
            }
        }
    }
}

struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyView()
    }
}
