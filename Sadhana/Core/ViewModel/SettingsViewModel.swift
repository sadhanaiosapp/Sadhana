import SwiftUI
import Firebase
import FirebaseFirestore

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var practiceID: String = ""
    @Published var frequency: String = "0"
    @Published var count: String = "0"
    @Published var mandalaCount: String = "0"
    @Published var mandalaDuration: String = "0"
    @Published var mandalasCompleted: String = "0"
    @Published var isDone: Bool = false
    
    @Published var friends: [Friend] = []
    @Published var friendRequests: [Friend] = []
    @Published var friendProfileUID: String = ""
    @Published var friendProfilePractices: [String] = []
    
    func fetchPracticeData(practiceID: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).collection("practices")
            .document(practiceID).getDocument() else {
            print("ERROR: Fetching data for individua practice from Firebase...")
            return
        }
        
        self.practiceID = practiceID
        self.frequency = snapshot["frequency"] as! String
        self.mandalaDuration = snapshot["mandalaDuration"] as! String
        self.mandalaCount = snapshot["mandalaCount"] as! String
        self.mandalasCompleted = snapshot["mandalasCompleted"] as! String
        self.count = snapshot["count"] as! String
        
        if self.mandalaDuration != "" {
            self.mandalaCount = "\(self.mandalaCount) / \(self.mandalaDuration)"
        } else {
            self.mandalaDuration = "Not Set"
            self.mandalaCount = "N/A"
        }
    }
    
    func fetchMyFriends(uid: String) async {
        let db = Firestore.firestore()
        self.friends = []
        
        do {
            let snapshot = try await db.collection("users").document(uid).getDocument().data()
            let userFriends = snapshot!["friends"] as! [String]
            
            for friendUID in userFriends {
                guard let friendData = try await db.collection("users").document(friendUID).getDocument().data() else { continue }
                let friendFullName = friendData["fullname"] as! String
                let friendEmail = friendData["email"] as! String
                self.friends.append(Friend(id: friendUID, fullname: friendFullName, email: friendEmail))
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchFriendProfile(email: String) async {
        let db = Firestore.firestore()
        
        do {
            //get friend uid
            let querySnapshot = try await db.collection("users")
                .whereField("email", isEqualTo: email)
                .getDocuments()
            for doc in querySnapshot.documents {
                let data = doc.data()
                self.friendProfileUID = data["id"] as! String
            }
            
            //get friend practices
            self.friendProfilePractices = []
            let snapshot = try await db.collection("users").document(friendProfileUID)
                .collection("practices").getDocuments()
            for doc in snapshot.documents {
                self.friendProfilePractices.append(doc.documentID)
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchFriendRequests(uid: String) async {
        let db = Firestore.firestore()
        self.friendRequests = []
        
        do {
            let snapshot = try await db.collection("users").document(uid).getDocument().data()
            let userFriends = snapshot!["friendRequests"] as! [String]
            
            for friendUID in userFriends {
                guard let friendData = try await db.collection("users").document(friendUID).getDocument().data() else { return }
                let friendFullName = friendData["fullname"] as! String
                let friendEmail = friendData["email"] as! String
                self.friendRequests.append(Friend(id: friendUID, fullname: friendFullName, email: friendEmail))
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updatePracticeInfo(uid: String, practice: String, dF: String, mD: String) async {
        let db = Firestore.firestore()
        
        do {
            try await db.collection("users").document(uid).collection("practices").document(practice)
                .updateData(["frequency": dF, "mandalaDuration": mD])
                
        } catch {
            print(error.localizedDescription)
        }
    }
}
