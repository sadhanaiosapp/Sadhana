import SwiftUI

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    var practices: [ToDoListItem] = []
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
}
