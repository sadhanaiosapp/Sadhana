import SwiftUI

struct ToDoListItem: Identifiable, Codable {
    let id: String
    var frequency: String
    var mandala: String
    var count: String
    var isDone: Bool = false

}
