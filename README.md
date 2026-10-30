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
    ├── SwiftUILabs
    │   ├── ContentView
    │   ├── CounterLab
    │   ├── WorkoutEditorSheet
    │   ├── WorkoutListLab
    │   └── WorkoutStatsLab
    └── TaskList
```

The SwiftUI labs are small, hands-on examples for `@State`, `List`,
`Identifiable`, and extracting a row into its own view. `ContentView` links to
each lab, and the TODO prompts are exercises to extend them while learning.
Workout entries are saved as Codable data in `UserDefaults`, sorted newest
first in the list, and summarized with a total distance. Entries can be edited,
searched by note, distance, or intensity, and filtered by intensity or to the
last 7 or 30 days. Deleting the last entry shows an empty state; changes persist
across app launches.
The statistics screen summarizes the current week's distance, workout count,
duration, and average pace, charts daily distances, and tracks a persistent
weekly distance goal.
The counter lab also preserves the current count and its goal across app
launches.

## Run tests

```bash
swift test
```

Open `SwiftLabApp.xcodeproj` in Xcode and run the `SwiftLabApp` scheme on an iOS
simulator. The app target uses this package as a local dependency. `Package.swift`
can still be used independently as a library or added to another iOS or macOS
application.
