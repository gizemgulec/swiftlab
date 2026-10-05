import SwiftUI

public struct WorkoutListLab: View {
    @Binding private var workouts: [Workout]

    public init(workouts: Binding<[Workout]>) {
        self._workouts = workouts
    }

    public var body: some View {
        List {
            ForEach(workouts) { workout in
                WorkoutRow(workout: workout)
            }
            .onDelete { workouts.remove(atOffsets: $0) }
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
    NavigationStack { WorkoutListLab(workouts: .constant(Workout.samples)) }
}