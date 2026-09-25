public actor InMemoryTaskRepository: TaskRepository {
    private var tasks: [TaskItem]

    public init(tasks: [TaskItem] = []) {
        self.tasks = tasks
    }

    public func fetchTasks() async throws -> [TaskItem] {
        tasks
    }
}
