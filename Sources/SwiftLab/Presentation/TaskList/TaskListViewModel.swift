import Foundation

@MainActor
public final class TaskListViewModel {
    public enum State: Equatable, Sendable {
        case idle
        case loading
        case loaded([TaskItem])
        case failed(String)
    }

    public private(set) var state: State = .idle
    private let fetchTasks: FetchTasksUseCase

    public init(fetchTasks: FetchTasksUseCase) {
        self.fetchTasks = fetchTasks
    }

    public func load() async {
        state = .loading

        do {
            state = .loaded(try await fetchTasks.execute())
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
