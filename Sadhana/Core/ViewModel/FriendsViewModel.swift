import SwiftUI
import Firebase
import FirebaseFirestore

@MainActor
class FriendsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var friends: [String] = []
    
    func addFriend(uid: String, email: String) async -> String {
        let db = Firestore.firestore()
        let friendEmail = email.lowercased()
        do {
            var friendUID = ""
            let querySnapshot = try await db.collection("users")
                                .whereField("email", isEqualTo: friendEmail)
                                .getDocuments()
            
            for document in querySnapshot.documents {
                let data = document.data()
                friendUID = data["id"] as! String
            }
            
            if friendUID == "" {
                return "No user with this email was found!"
            }
            
            let snapshot = try await db.collection("users").document(uid).getDocument().data()
            var userFriends = snapshot!["friends"] as! [String]
            userFriends.append(friendUID)
            try await db.collection("users").document(uid)
                .updateData(["friends": userFriends])
            
        } catch {
            return "There was an error while adding this user!"
        }
        
        return ""
    }
    
    func postSadhanaUpdate(isDone: Bool, time: Timestamp, uid: String, email: String, statement: String) async {
        
        let db = Firestore.firestore()

        
        if isDone {
            //add to the posts collection
            do {
                for friendUID in self.friends {
                    let docRef = db.collection("users").document(friendUID).collection("feed").document()
                    try await docRef.setData(["id": docRef.documentID, "statement": statement, "time": time, "user": email])
                }
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
        }
        
        else {
            //remove from the posts collection by doing query on statement
            do {
                for friendUID in self.friends {
                    let querySnapshot = try await db.collection("users").document(friendUID).collection("feed")
                        .whereField("statement", isEqualTo: statement)
                        .getDocuments()
                    
                    for document in querySnapshot.documents {
                        let docID = document.documentID
                        try await db.collection("users").document(friendUID).collection("feed").document(docID).delete()
                    }
                }

            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchPosts(uid: String) async {
        do {
            self.posts = []
            let userDocSnapshot = try await Firestore.firestore().collection("users").document(uid).getDocument().data()
            self.friends = userDocSnapshot!["friends"] as! [String]
            
            let snapshot = try await Firestore.firestore().collection("users").document(uid).collection("feed").order(by: "time", descending: true).getDocuments()
            
            for document in snapshot.documents {
                let data = document.data()
                let timeStamp = data["time"] as! Timestamp
                let post = Post(id: document.documentID, statement: data["statement"] as! String, date: timeStamp, user: data["user"] as! String)
                self.posts.append(post)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}


