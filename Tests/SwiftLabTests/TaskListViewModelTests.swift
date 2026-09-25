import XCTest
@testable import SwiftLab

@MainActor
final class TaskListViewModelTests: XCTestCase {
    func testLoadPublishesTasks() async {
        let tasks = [TaskItem(title: "Mimariyi kur")]
        let repository = InMemoryTaskRepository(tasks: tasks)
        let viewModel = TaskListViewModel(
            fetchTasks: FetchTasksUseCase(repository: repository)
        )

        await viewModel.load()

        XCTAssertEqual(viewModel.state, .loaded(tasks))
    }
}
