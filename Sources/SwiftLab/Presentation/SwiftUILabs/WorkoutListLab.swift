import SwiftUI

public struct WorkoutListLab: View {
    @Binding private var workouts: [Workout]

    public init(workouts: Binding<[Workout]>) {
        self._workouts = workouts
    }

    public var body: some View {
        List {
            if workouts.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "figure.run")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("Henüz antrenman yok")
                        .font(.headline)
                    Text("Yeni antrenman ekleyerek başlayın.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, minHeight: 220)
                .listRowSeparator(.hidden)
            } else {
                Section {
                    ForEach(sortedWorkouts) { workout in
                        WorkoutRow(workout: workout)
                    }
                    .onDelete { offsets in
                        let ids = offsets.map { sortedWorkouts[$0].id }
                        workouts.removeAll { ids.contains($0.id) }
                    }
                } header: {
                    Text("Toplam mesafe: \(totalDistance) m")
                }
            }
        }
        .navigationTitle("Antrenmanlar")
    }

    private var sortedWorkouts: [Workout] {
        workouts.sorted { $0.date > $1.date }
    }

    private var totalDistance: Int {
        workouts.reduce(0) { $0 + $1.distance }
    }
}

private struct WorkoutRow: View {
    let workout: Workout

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(workout.date, style: .date)
                .font(.headline)

            Text("\(workout.distance) m · \(workout.duration) dk")
                .foregroundStyle(.secondary)

            if !workout.note.isEmpty {
                Text(workout.note)
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack { WorkoutListLab(workouts: .constant(Workout.samples)) }
}