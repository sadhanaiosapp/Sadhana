import SwiftUI
import Firebase
import FirebaseFirestore

@MainActor
class FriendsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    init() {
        Task {
            await fetchPosts()
        }
    }
    
    func addFriend() {
        
    }
    
    func createNewPost() {
        
    }
    
    func postSadhanaUpdate(isDone: Bool, time: Timestamp, name: String, practice: String, email: String) async {
        
        let db = Firestore.firestore()
        let statement = "\(name) finished \(practice)"
        if isDone {
            //add to the posts collection
            do {
                let docRef = db.collection("posts").document()
                try await docRef.setData(["id": docRef.documentID, "statement": statement, "time": time, "user": email])
                
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
        }
        
        else {
            //remove from the posts collection by doing query on statement
            db.collection("posts")
                .whereField("statement", isEqualTo: statement)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        print("ERROR: \(error.localizedDescription)")
                    } else {
                        for document in querySnapshot!.documents {
                            let docID = document.documentID
                            
                            db.collection("posts").document(docID).delete { error in
                                if let error = error {
                                    print("ERROR: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
        }
    }
    
    func fetchPosts() async {
        //ADD QUERY TO ONLY FETCH POSTS OF FRIENDS
        self.posts = []
        guard let snapshot = try? await Firestore.firestore().collection("posts").getDocuments() else { return }
        
        for document in snapshot.documents {
            var data = document.data()
            let timeStamp = data["time"] as! Timestamp
            let post = Post(id: document.documentID, statement: data["statement"] as! String, date: timeStamp, user: data["user"] as! String)
            self.posts.append(post)
        }
    }
}


