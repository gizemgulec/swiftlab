public protocol TaskRepository: Sendable {
    func fetchTasks() async throws -> [TaskItem]
}
