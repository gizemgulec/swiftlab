import SwiftUI

public struct WorkoutListLab: View {
    @Binding private var workouts: [Workout]
    @State private var searchText = ""
    @State private var selectedPeriod = WorkoutListFilter.Period.all
    @State private var workoutToEdit: Workout?

    public init(workouts: Binding<[Workout]>) {
        self._workouts = workouts
    }

    public var body: some View {
        List {
            if workouts.isEmpty {
                emptyState(
                    title: "Henüz antrenman yok",
                    message: "Yeni antrenman ekleyerek başlayın.",
                    symbol: "figure.run"
                )
            } else if visibleWorkouts.isEmpty {
                emptyState(
                    title: "Antrenman bulunamadı",
                    message: "Aramanızı veya filtreyi değiştirmeyi deneyin.",
                    symbol: "magnifyingglass"
                )
            } else {
                Section {
                    ForEach(visibleWorkouts) { workout in
                        WorkoutRow(workout: workout) {
                            workoutToEdit = workout
                        }
                    }
                    .onDelete { offsets in
                        let ids = offsets.map { visibleWorkouts[$0].id }
                        workouts.removeAll { ids.contains($0.id) }
                    }
                } header: {
                    Text("Toplam mesafe: \(totalDistance) m · \(visibleWorkouts.count) antrenman")
                }
            }
        }
        .navigationTitle("Antrenmanlar")
        .searchable(text: $searchText, prompt: "Not veya mesafe ara")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Picker("Dönem", selection: $selectedPeriod) {
                        ForEach(WorkoutListFilter.Period.allCases) { period in
                            Text(period.title).tag(period)
                        }
                    }
                } label: {
                    Label("Dönem filtresi", systemImage: "line.3.horizontal.decrease")
                }
            }
        }
        .sheet(item: $workoutToEdit) { workout in
            WorkoutEditorSheet(workout: workout) { updatedWorkout in
                guard let index = workouts.firstIndex(where: { $0.id == updatedWorkout.id }) else {
                    return
                }
                workouts[index] = updatedWorkout
            }
        }
    }

    private var visibleWorkouts: [Workout] {
        WorkoutListFilter(query: searchText, period: selectedPeriod).apply(to: workouts)
    }

    private var totalDistance: Int {
        visibleWorkouts.reduce(0) { $0 + $1.distance }
    }

    private func emptyState(title: String, message: String, symbol: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 220)
        .listRowSeparator(.hidden)
    }
}

private struct WorkoutRow: View {
    let workout: Workout
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
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
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityHint("Antrenmanı düzenlemek için aç")
    }
}

#Preview {
    NavigationStack { WorkoutListLab(workouts: .constant(Workout.samples)) }
}

struct WorkoutListFilter {
    enum Period: String, CaseIterable, Identifiable {
        case all
        case week
        case month

        var id: Self { self }

        var title: String {
            switch self {
            case .all: "Tüm zamanlar"
            case .week: "Son 7 gün"
            case .month: "Son 30 gün"
            }
        }
    }

    var query: String = ""
    var period: Period = .all

    func apply(
        to workouts: [Workout],
        now: Date = .now,
        calendar: Calendar = .current
    ) -> [Workout] {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let cutoff: Date?
        switch period {
        case .all:
            cutoff = nil
        case .week:
            cutoff = calendar.date(byAdding: .day, value: -7, to: now)
        case .month:
            cutoff = calendar.date(byAdding: .day, value: -30, to: now)
        }

        return workouts
            .filter { workout in
                let matchesQuery = trimmedQuery.isEmpty
                    || workout.note.localizedCaseInsensitiveContains(trimmedQuery)
                    || String(workout.distance).localizedCaseInsensitiveContains(trimmedQuery)
                let matchesPeriod = cutoff.map { workout.date >= $0 } ?? true
                return matchesQuery && matchesPeriod
            }
            .sorted { $0.date > $1.date }
    }
}