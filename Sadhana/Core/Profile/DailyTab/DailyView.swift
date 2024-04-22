import SwiftUI
import Firebase
import FirebaseFirestore

struct DailyView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationStack {
                VStack() {
                    List(user.practices) { item in
                        ToDoListItemView(item: item)
                    }
                    .listStyle(PlainListStyle())
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
