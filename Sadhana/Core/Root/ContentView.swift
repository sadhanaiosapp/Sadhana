import SwiftUI
import Firebase
import FirebaseFirestore

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                TabView {
                    DailyView()
                        .tabItem{
                            Label("Daily", systemImage: "house.fill")
                        }
                    
                    CalenderView()
                        .tabItem{
                            Label("Calender", systemImage: "calendar")
                        }
                    
                    FriendsView()
                        .tabItem{
                            Label("Friends", systemImage: "person.3.fill")
                        }
                    
                    ProfileView()
                        .tabItem{
                            Label("Profile", systemImage: "person.circle.fill")
                        }
                }
                
            } else {
                LogInView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
