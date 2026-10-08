import SwiftUI

public struct ContentView: View {
    @State private var workouts: [Workout]
    @State private var persistenceError: String?

    public init() {
        do {
            _workouts = State(initialValue: try WorkoutPersistence.load() ?? Workout.samples)
            _persistenceError = State(initialValue: nil)
        } catch {
            _workouts = State(initialValue: Workout.samples)
            _persistenceError = State(initialValue: error.localizedDescription)
        }
    }

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
        .onChange(of: workouts) { workouts in
            do {
                try WorkoutPersistence.save(workouts)
                persistenceError = nil
            } catch {
                persistenceError = error.localizedDescription
            }
        }
        .alert("Antrenmanlar kaydedilemedi", isPresented: persistenceErrorPresented) {
            Button("Tamam", role: .cancel) {}
        } message: {
            Text(persistenceError ?? "Bilinmeyen bir hata oluştu.")
        }
    }

    private var persistenceErrorPresented: Binding<Bool> {
        Binding(
            get: { persistenceError != nil },
            set: { if !$0 { persistenceError = nil } }
        )
    }
}

#Preview {
    ContentView()
}