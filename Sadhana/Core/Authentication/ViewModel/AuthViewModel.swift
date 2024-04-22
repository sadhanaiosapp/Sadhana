import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User? //controller for presentation view (profile vs. log in)
    @Published var currentUser: User? //model for user information
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Error while signing in of \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            
            let jsonEncodedUser = try JSONEncoder().encode(user)
            guard let userDictionary = try JSONSerialization.jsonObject(with: jsonEncodedUser, options: []) as? [String: Any] else {
                fatalError("Failed to convert JSON data to dictionary")
            }
            try await Firestore.firestore().collection("users").document(user.id).setData(userDictionary)
            
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() //signs out user in backend
            self.userSession = nil //switches controller view back to log-in
            self.currentUser = nil //clears user information
        } catch {
            print("DEBUG: Sign Out Error is \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        print("Deleting account...")
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        if let userData = snapshot.data(){
            let user = User(id: userData["id"] as? String ?? "", fullname: userData["fullname"] as? String ?? "",  email: userData["email"] as? String ?? "")
            self.currentUser = user
        } else {
            self.currentUser = nil
        }
        
        print("Fetching user data ... Current user is \(String(describing: self.currentUser))")
    }
}
