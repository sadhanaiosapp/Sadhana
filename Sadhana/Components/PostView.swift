import SwiftUI
import Firebase
import FirebaseFirestore

struct PostView: View {
    let statement: String
    let date: Timestamp
    let user: String
    
    var dateString: String {
        let date = date.dateValue()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm a"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(statement)
                .font(.headline)
                .foregroundColor(.black)
                .padding(.horizontal)
            
            Text(dateString)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            Text("By \(user)")
                .font(.caption)
                .foregroundColor(.blue)
                .padding(.horizontal)
        }
        .frame(width: UIScreen.main.bounds.width - 32)
        .padding(.vertical, 10)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 5)
    }
}

//struct PostView_Previews: PreviewProvider {
//    static var previews: some View {
////        PostView(statement: "Prameela finished Shakti Chalana Kriya", date: "11:31 a.m.", user: "Prameela Thupilli")
//    }
//}
