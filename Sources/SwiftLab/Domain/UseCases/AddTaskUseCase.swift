public struct AddTaskUseCase: Sendable {
    private let repository: any TaskRepository

    public init(repository: any TaskRepository) {
        self.repository = repository
    }

    public func execute(title: String) async throws -> TaskItem {
        try await repository.addTask(title: title)
    }
}
