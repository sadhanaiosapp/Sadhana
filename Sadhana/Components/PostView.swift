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
                .foregroundColor(.primary)
            
            HStack {
                Text(dateString)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(user)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 5)
        )
        .padding(10)
    }
}
