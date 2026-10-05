import SwiftUI

public struct ContentView: View {
    @State private var workouts = Workout.samples

    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                Section("Temeller") {
                    NavigationLink("01 · @State – Sayaç") { CounterLab() }
                    NavigationLink("02 · List – Antrenmanlar") {
                        WorkoutListLab(workouts: $workouts)
                    }
                    NavigationLink("03 · Form – Yeni Antrenman") {
                        FormLab(savedWorkouts: $workouts)
                    }
                }
            }
            .navigationTitle("SwiftLab")
        }
    }
}

#Preview {
    ContentView()
}