import SwiftUI
import Firebase
import FirebaseFirestore

struct ToDoListItemView: View {
    var item: ToDoListItem
    var index: Int
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var friendsViewModel: FriendsViewModel
    
    
    var body: some View {
        
        if viewModel.currentUser != nil {
            let practice = (viewModel.currentUser?.practices[index].id)!
            // Check if there's a stored value for isDone in UserDefaults
            var isDone = UserDefaults.standard.bool(forKey: practice)
            
            Button {
                viewModel.currentUser?.practices[index].isDone = isDone
                viewModel.currentUser?.practices[index].isDone.toggle()
                isDone = viewModel.currentUser?.practices[index].isDone ?? false
                UserDefaults.standard.set(isDone, forKey: practice)
                
                let uid = viewModel.currentUser?.id
                let name = viewModel.currentUser?.fullname
                let email = viewModel.currentUser?.email
                let statement = "\(name!) finished \(practice)"
                Task {
                    await friendsViewModel.postSadhanaUpdate(isDone: isDone, time: Timestamp.init(), uid: uid!, email: email!, statement: statement)
                }
                
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(item.id)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(isDone ? .white : .blue)
                        
                        Text("Daily Frequency: \(item.frequency)")
                            .font(.footnote)
                            .foregroundColor(Color(isDone ? .white : .secondaryLabel))
                        
                        if item.mandala != "" {
                            Text("Mandala: \(item.mandalaCount) / \(item.mandala)")
                                .font(.footnote)
                                .foregroundColor(Color(isDone ? .white : .secondaryLabel))
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(Color(isDone ? .white : .blue))
                }
                .padding()
                .background(isDone ? Color.green : Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
        }
    }
}
//
//struct ToDoListItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ToDoListItemView(item: ToDoListItem(id: "Shoonya", frequency: "2", mandala: "40", count: "0"), index: 0)
//    }
//}
