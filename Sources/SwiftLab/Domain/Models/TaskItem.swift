import Foundation

public struct TaskItem: Identifiable, Equatable, Sendable {
    public let id: UUID
    public let title: String
    public let isCompleted: Bool

    public init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}
