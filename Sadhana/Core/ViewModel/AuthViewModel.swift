import SwiftUI
import Firebase
import FirebaseFirestore

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
            await checkForNewDay()
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
            let friends: [String] = [user.id]
            let friendRequests: [String] = []
            try await Firestore.firestore().collection("users").document(user.id).setData(["id": user.id, "fullname": user.fullname, "email": user.email, "friends": friends, "friendRequests": friendRequests])
            
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil //switches controller view back to log-in
            self.currentUser = nil //clears user information
            UserDefaults.standard.set("", forKey: "user")
        } catch {
            print("DEBUG: Sign Out Error is \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                print("DEBUG: Account Deletion Error is \(error.localizedDescription)")
            }
            
            else {
                self.userSession = nil
                self.currentUser = nil
            }
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        
        if let userData = snapshot.data(){
            let user = User(id: userData["id"] as? String ?? "", fullname: userData["fullname"] as? String ?? "",  email: userData["email"] as? String ?? "")
            self.currentUser = user
            UserDefaults.standard.set(user.id, forKey: "user")
            
            //FETCH USER PRACTICES - COULD BE THE REASON FOR SLOW BOOTUP
            let snapshot = try? await Firestore.firestore().collection("users").document(uid).collection("practices").getDocuments()
            
            self.currentUser?.practices = []
            if snapshot != nil {
                for document in snapshot!.documents {
                    let data = document.data()
                    let item = ToDoListItem(id: document.documentID, frequency: data["frequency"] as! String, mandalasCompleted: data["mandalasCompleted"] as! String, mandalaDuration: data["mandalaDuration"] as! String,
                                            mandalaCount: data["mandalaCount"] as! String, count: data["count"] as! String)
                    self.currentUser?.practices.append(item)
                }
            }

        } else {
            self.currentUser = nil
        }
        
        print("Fetching user data ... Current user is \(String(describing: self.currentUser?.email))")
    }
    
    func checkForNewDay() async {
        let currentDate = Date()
        
        guard let lastDate = UserDefaults.standard.object(forKey: "lastDate") as? Date else {
            UserDefaults.standard.set(currentDate, forKey: "lastDate")
            return
        }
        
        let calendar = Calendar.current
        
        //NEW DAY: RESET CHECKLIST TO NOT DONE && UPDATES FIREBASE WITH NEW COUNTS
        if !calendar.isDate(currentDate, inSameDayAs: lastDate) {
            UserDefaults.standard.set(currentDate, forKey: "lastDate")
            let isDone = resetSadhana()
            await updateFirebase(lastDay: lastDate, isDone: isDone)
        }
    }
    
    func resetSadhana() -> [Bool] {
        var isDone: [Bool] = []
        for index in currentUser!.practices.indices {
            let defaults = UserDefaults.standard
            let practice = currentUser!.practices[index]
            if defaults.bool(forKey: practice.id) == true {
                isDone.append(true)
            } else {
                isDone.append(false)
            }
            UserDefaults.standard.set(false, forKey: practice.id)
        }
        return isDone
    }
    
    func updateFirebase(lastDay: Date, isDone: [Bool]) async {
        do {
            let formattedDate = lastDay.string().replacingOccurrences(of: "/", with: ".")
            var allFinished = true
            var calendarDict: [String: Bool] = [:]
            
            for index in currentUser!.practices.indices {
                let practice = currentUser!.practices[index]
                var oldPracticeCount = Int(practice.count)
                var oldMandalaCount = Int(practice.mandalaCount)
                var oldMandalasCompleted = Int(practice.mandalasCompleted)
                
                if isDone[index] == true {
                    //update liftime count
                    oldPracticeCount = oldPracticeCount! + 1
                    currentUser!.practices[index].count = String(oldPracticeCount!)
                    
                    //update mandala count
                    if practice.mandalaDuration != "" {
                        oldMandalaCount = oldMandalaCount! + 1
                        if String(oldMandalaCount!) == practice.mandalaDuration {
                            oldMandalasCompleted = oldMandalasCompleted! + 1
                        }
                        currentUser!.practices[index].mandalaCount = String(oldMandalaCount!)
                        currentUser!.practices[index].mandalasCompleted = String(oldMandalasCompleted!)
                    }
                
                    calendarDict[practice.id] = true
                }
                
                else {
                    allFinished = false
                    
                    //mandala broken
                    if practice.mandalaDuration != "" {
                        oldMandalaCount = 0
                        currentUser!.practices[index].mandalaCount = "0"
                    }
                    
                    calendarDict[practice.id] = false
                }
                
                //update counts in firebase for previous day
                try await Firestore.firestore().collection("users").document(currentUser!.id)
                    .collection("practices").document(practice.id)
                    .updateData(["count": String(oldPracticeCount!), "mandalaCount": String(oldMandalaCount!), "mandalasCompleted": String(oldMandalasCompleted!)])
            }
            
            let dot = allFinished ? "#2ECC71" : "#E74C3C"
            
            //update calendar collection
            try await Firestore.firestore().collection("users").document(currentUser!.id)
                .collection("calendar").document(formattedDate)
                .setData(calendarDict)
            
            //update dots collection
            try await Firestore.firestore().collection("users").document(currentUser!.id)
                .collection("dots").document(lastDay.monthAndYear())
                .setData(["\(formattedDate)": dot], merge: true)
            
            //reset user feed
            let feed = try await Firestore.firestore().collection("users").document(currentUser!.id)
                .collection("feed").getDocuments()
            for doc in feed.documents {
                try await doc.reference.delete()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

