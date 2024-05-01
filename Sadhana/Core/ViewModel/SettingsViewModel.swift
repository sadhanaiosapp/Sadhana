import SwiftUI
import Firebase
import FirebaseFirestore

@MainActor
class SettingsViewModel: ObservableObject {
    
    @Published var practiceID: String = ""
    @Published var frequency: String = "0"
    @Published var mandala: String = "0"
    @Published var mandalaCount: String = "0"
    @Published var count: String = "0"
    @Published var isDone: Bool = false

    func fetchPracticeData(practiceID: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).collection("practices")
                .document(practiceID).getDocument() else {
            print("ERROR: Fetching data for individua practice from Firebase...")
            return
        }
        
        self.practiceID = practiceID
        self.frequency = snapshot["frequency"] as! String
        self.mandala = snapshot["mandala"] as! String
        self.mandalaCount = snapshot["mandalaCount"] as! String
        self.count = snapshot["count"] as! String
    }
    
    func fetchMyFriends() async {
        
    }
}
