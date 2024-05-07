import SwiftUI

struct ToDoListItem: Identifiable, Codable {
    let id: String
    var frequency: String
    var mandalasCompleted: String
    var mandalaDuration: String
    var mandalaCount: String
    var count: String
    var isDone: Bool = false
}
