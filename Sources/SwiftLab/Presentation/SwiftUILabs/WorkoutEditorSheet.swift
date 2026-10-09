import SwiftUI

struct WorkoutEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var date: Date
    @State private var distance: Int
    @State private var duration: Int
    @State private var note: String

    let workout: Workout
    let onSave: (Workout) -> Void

    init(workout: Workout, onSave: @escaping (Workout) -> Void) {
        self.workout = workout
        self.onSave = onSave
        _date = State(initialValue: workout.date)
        _distance = State(initialValue: workout.distance)
        _duration = State(initialValue: workout.duration)
        _note = State(initialValue: workout.note)
    }

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Tarih", selection: $date, in: ...Date.now, displayedComponents: .date)

                TextField("Mesafe (m)", value: $distance, format: .number)
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    #endif

                Stepper("Süre (dk): \(duration)", value: $duration, in: 1...1_440)

                TextField("Not", text: $note, axis: .vertical)
                    .lineLimit(3...5)
            }
            .navigationTitle("Antrenmanı Düzenle")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Vazgeç") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet", action: save)
                        .disabled(distance <= 0 || duration <= 0)
                }
            }
        }
    }

    private func save() {
        guard distance > 0, duration > 0 else { return }
        onSave(
            Workout(
                id: workout.id,
                date: date,
                distance: distance,
                duration: duration,
                note: note.trimmingCharacters(in: .whitespacesAndNewlines)
            )
        )
        dismiss()
    }
}
