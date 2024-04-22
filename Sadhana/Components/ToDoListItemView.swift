import SwiftUI
import Firebase
import FirebaseFirestore

struct ToDoListItemView: View {
    var item: ToDoListItem
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if var user = viewModel.currentUser {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(item.id)
                        .font(.subheadline)

                    Text("Daily Frequency: \(item.frequency)")
                        .font(.footnote)
                        .foregroundColor(Color(.secondaryLabel))
                }
                
                Spacer()
                
                Button {
                    
                    //UPDATE COUNT IN FIREBASE
                } label: {
                    Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                }
            }
        }
    }
}

struct ToDoListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListItemView(item: ToDoListItem(id: "Shoonya", frequency: "2", mandala: "40", count: "3"))
    }
}
