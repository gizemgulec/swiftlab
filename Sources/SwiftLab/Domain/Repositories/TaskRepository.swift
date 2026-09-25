public protocol TaskRepository: Sendable {
    func fetchTasks() async throws -> [TaskItem]
    func addTask(title: String) async throws -> TaskItem
    func toggleTask(id: TaskItem.ID) async throws -> TaskItem
}
