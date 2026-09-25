# SwiftLab

A platform-independent, testable foundation for Swift projects.

## Architecture

The code is organized into three layers. Dependencies point from the outer
layers toward the abstractions in the Domain layer:

```text
Presentation  ->  Domain  <-  Data
```

- `Domain/Models`: Business models that know nothing about UI or data sources.
- `Domain/Repositories`: Repository protocols used by use cases.
- `Domain/UseCases`: Application rules, with one focused operation per use case.
- `Data/Repositories`: Concrete data sources such as APIs, databases, or memory.
- `Presentation`: View models and UI state consumed by SwiftUI or UIKit screens.

The current task-list example supports loading, creating, and toggling tasks:

```text
TaskListView
    -> TaskListViewModel
    -> FetchTasksUseCase / AddTaskUseCase / ToggleTaskUseCase
    -> TaskRepository
                         <- InMemoryTaskRepository
```

`TaskRepository` keeps the Domain and Presentation layers independent from the
storage implementation. A real API or persistent database can be added under
`Data` without changing the feature's business rules.

## Project structure

```text
Sources/SwiftLab
├── Domain
│   ├── Models
│   ├── Repositories
│   └── UseCases
├── Data
│   └── Repositories
└── Presentation
    └── TaskList
```

## Run tests

```bash
swift test
```

Open `Package.swift` in Xcode to use the package as a library or add it as a
dependency to an iOS or macOS application.
