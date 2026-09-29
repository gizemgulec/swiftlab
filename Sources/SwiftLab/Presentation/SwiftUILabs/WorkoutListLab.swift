import SwiftUI

public struct WorkoutListLab: View {
    @State private var workouts = Workout.samples

    public init() {}

    public var body: some View {
        List(workouts) { workout in
            WorkoutRow(workout: workout)
        }
        .navigationTitle("Antrenmanlar")
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

// GÖREVLER:
// 1. Kaydırarak silme ekle (ipucu: List { ForEach { } .onDelete { } })
// 2. Listenin en üstüne toplam mesafeyi gösteren bir Section ekle
// 3. Workout'ları tarihe göre sırala (ipucu: sorted(by:))

#Preview {
    NavigationStack { WorkoutListLab() }
}