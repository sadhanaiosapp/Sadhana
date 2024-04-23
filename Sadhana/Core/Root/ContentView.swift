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
                            Label("Daily", systemImage: "1.circle")
                        }
                    
                    CalenderView()
                        .tabItem{
                            Label("Calender", systemImage: "2.circle")
                        }
                    
                    FriendsView()
                        .tabItem{
                            Label("Friends", systemImage: "3.circle")
                        }
                    
                    ProfileView()
                        .tabItem{
                            Label("Profile", systemImage: "4.circle")
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
