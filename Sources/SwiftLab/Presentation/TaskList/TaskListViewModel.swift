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
    private let addTask: AddTaskUseCase
    private let toggleTask: ToggleTaskUseCase

    public init(
        fetchTasks: FetchTasksUseCase,
        addTask: AddTaskUseCase,
        toggleTask: ToggleTaskUseCase
    ) {
        self.fetchTasks = fetchTasks
        self.addTask = addTask
        self.toggleTask = toggleTask
    }

    public func load() async {
        state = .loading

        do {
            state = .loaded(try await fetchTasks.execute())
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    public func createTask(title: String) async {
        do {
            _ = try await addTask.execute(title: title)
            await load()
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    public func toggleTask(id: TaskItem.ID) async {
        do {
            _ = try await toggleTask.execute(id: id)
            await load()
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
