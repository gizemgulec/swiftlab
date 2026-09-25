public struct FetchTasksUseCase: Sendable {
    private let repository: any TaskRepository

    public init(repository: any TaskRepository) {
        self.repository = repository
    }

    public func execute() async throws -> [TaskItem] {
        try await repository.fetchTasks()
    }
}
