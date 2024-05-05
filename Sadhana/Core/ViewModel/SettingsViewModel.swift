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
    
    @Published var friends: [Friend] = []
    
    init() {
        Task {
            let uid = UserDefaults.standard.string(forKey: "user")
            await self.fetchMyFriends(uid: uid!)
        }
    }

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
    
    func fetchMyFriends(uid: String) async {
        let db = Firestore.firestore()
        self.friends = []
        
        do {
            let snapshot = try await db.collection("users").document(uid).getDocument().data()
            let userFriends = snapshot!["friends"] as! [String]
            
            for friendUID in userFriends {
                let friendData = try await db.collection("users").document(friendUID).getDocument().data()
                let friendFullName = friendData!["fullname"] as! String
                let friendEmail = friendData!["email"] as! String
                self.friends.append(Friend(id: friendUID, fullname: friendFullName, email: friendEmail))
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
