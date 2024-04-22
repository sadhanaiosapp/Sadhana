import SwiftUI

struct ToDoListItem: Identifiable, Codable {
    let id: String
    let frequency: String
    let mandala: String
    let count: String
    var isDone: Bool = false
}
