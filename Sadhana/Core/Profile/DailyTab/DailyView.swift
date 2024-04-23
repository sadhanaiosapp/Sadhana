import SwiftUI
import Firebase
import FirebaseFirestore

struct DailyView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack {
                VStack() {
                    List {
                        ForEach(user.practices.indices, id: \.self) { index in
                            ToDoListItemView(item: user.practices[index], index: index)
                        }
                    }
                }
                .navigationTitle("Daily Sadhana")
                .toolbar(content:  {
                    Menu {
                        NavigationLink { //Add New Sadhana Button
                            NewSadhanaView()
                        } label: {
                            Label("New Daily Sadhana", systemImage: "gear")
                        }
                            
                        NavigationLink { //Start New Mandala Button
                            NewMandalaView()
                        } label: {
                            Label("Start New Mandala", systemImage: "gear")
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
