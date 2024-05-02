import SwiftUI
import Firebase
import FirebaseFirestore

struct Post: Identifiable, Codable {
    let id: String 
    let statement: String
    let date: Timestamp
    let user: String
}
