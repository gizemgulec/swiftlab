import XCTest
@testable import SwiftLab

@MainActor
final class TaskListViewModelTests: XCTestCase {
    func testLoadPublishesTasks() async {
        let tasks = [TaskItem(title: "Mimariyi kur")]
        let repository = InMemoryTaskRepository(tasks: tasks)
        let viewModel = TaskListViewModel(
            fetchTasks: FetchTasksUseCase(repository: repository),
            addTask: AddTaskUseCase(repository: repository),
            toggleTask: ToggleTaskUseCase(repository: repository)
        )

        await viewModel.load()

        XCTAssertEqual(viewModel.state, .loaded(tasks))
    }

    func testCreateTaskReloadsTasks() async {
        let repository = InMemoryTaskRepository()
        let viewModel = TaskListViewModel(
            fetchTasks: FetchTasksUseCase(repository: repository),
            addTask: AddTaskUseCase(repository: repository),
            toggleTask: ToggleTaskUseCase(repository: repository)
        )

        await viewModel.createTask(title: "Write tests")

        guard case let .loaded(tasks) = viewModel.state else {
            return XCTFail("Expected loaded state")
        }
        XCTAssertEqual(tasks.map(\.title), ["Write tests"])
    }

    func testToggleTaskReloadsUpdatedTask() async {
        let task = TaskItem(title: "Review architecture")
        let repository = InMemoryTaskRepository(tasks: [task])
        let viewModel = TaskListViewModel(
            fetchTasks: FetchTasksUseCase(repository: repository),
            addTask: AddTaskUseCase(repository: repository),
            toggleTask: ToggleTaskUseCase(repository: repository)
        )

        await viewModel.toggleTask(id: task.id)

        XCTAssertEqual(viewModel.state, .loaded([
            TaskItem(id: task.id, title: task.title, isCompleted: true)
        ]))
    }
}
