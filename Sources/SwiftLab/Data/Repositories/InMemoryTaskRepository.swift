public actor InMemoryTaskRepository: TaskRepository {
    private var tasks: [TaskItem]

    public init(tasks: [TaskItem] = []) {
        self.tasks = tasks
    }

    public func fetchTasks() async throws -> [TaskItem] {
        tasks
    }

    public func addTask(title: String) async throws -> TaskItem {
        let task = TaskItem(title: title)
        tasks.append(task)
        return task
    }

    public func toggleTask(id: TaskItem.ID) async throws -> TaskItem {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else {
            throw RepositoryError.taskNotFound(id)
        }

        let currentTask = tasks[index]
        let updatedTask = TaskItem(
            id: currentTask.id,
            title: currentTask.title,
            isCompleted: !currentTask.isCompleted
        )
        tasks[index] = updatedTask
        return updatedTask
    }
}

public enum RepositoryError: Error, Equatable {
    case taskNotFound(TaskItem.ID)
}
