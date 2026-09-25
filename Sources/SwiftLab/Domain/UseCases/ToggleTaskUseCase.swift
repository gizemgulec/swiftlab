public struct ToggleTaskUseCase: Sendable {
    private let repository: any TaskRepository

    public init(repository: any TaskRepository) {
        self.repository = repository
    }

    public func execute(id: TaskItem.ID) async throws -> TaskItem {
        try await repository.toggleTask(id: id)
    }
}
