import SwiftUI

public struct FormLab: View {
    private enum Field: Hashable {
        case distance, note
    }

    @Binding private var savedWorkouts: [Workout]
    @State private var draft = WorkoutDraft()
    @FocusState private var focusedField: Field?

    private var durationBinding: Binding<Int> {
        Binding(
            get: { draft.duration ?? 0 },
            set: { draft.duration = $0 == 0 ? nil : $0 }
        )
    }

    public init(savedWorkouts: Binding<[Workout]>) {
        self._savedWorkouts = savedWorkouts
    }

    public var body: some View {
        Form {
            Section("Antrenman") {
                DatePicker("Tarih", selection: $draft.date, in: ...Date.now, displayedComponents: .date)

                Picker("Yoğunluk", selection: $draft.intensity) {
                    ForEach(WorkoutDraft.Intensity.allCases) { intensity in
                        Text(intensity.rawValue).tag(intensity)
                    }
                }
            }

            Section {
                TextField("Mesafe (m)", value: $draft.distance, format: .number)
                    .focused($focusedField, equals: .distance)
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    #endif

                Stepper(
                    "Süre (dk): \(draft.duration ?? 0)",
                    value: durationBinding,
                    in: 0...1_440,
                    step: 5
                )
            } header: {
                Text("Değerler")
            } footer: {
                if let distance = draft.distance, distance > 42_195 {
                    Text("Maraton mu kürek mi? 😄")
                }
            }

            Section {
                Toggle("Not ekle", isOn: $draft.hasNote.animation())

                if draft.hasNote {
                    TextField("Not", text: $draft.note, axis: .vertical)
                        .lineLimit(3...5)
                        .focused($focusedField, equals: .note)
                }
            }

            Section {
                Button("Kaydet", action: save)
                    .disabled(!draft.isValid)
            }

            if !savedWorkouts.isEmpty {
                Section("Kaydedilenler") {
                    ForEach(savedWorkouts) { workout in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(workout.date, style: .date)
                                .font(.headline)
                            Text("\(workout.intensity.rawValue) · \(workout.distance) m · \(workout.duration) dk")
                                .foregroundStyle(.secondary)
                            if !workout.note.isEmpty {
                                Text(workout.note)
                                    .font(.caption)
                            }
                        }
                    }
                    .onDelete { savedWorkouts.remove(atOffsets: $0) }
                }
            }
        }
        .navigationTitle("Yeni Antrenman")
    }

    private func save() {
        guard draft.isValid,
              let distance = draft.distance,
              let duration = draft.duration
        else { return }

        let trimmedNote = draft.hasNote
            ? draft.note.trimmingCharacters(in: .whitespacesAndNewlines)
            : ""

        let workout = Workout(
            date: draft.date,
            distance: distance,
            duration: duration,
            intensity: draft.intensity,
            note: trimmedNote
        )
        savedWorkouts.insert(workout, at: 0)
        reset()
    }

    private func reset() {
        draft = WorkoutDraft()
        focusedField = nil
    }
}

// RN KARŞILIKLARI:
// - @State + TextField(value:)  ≈  useState + controlled <TextInput value onChangeText>
// - @FocusState                 ≈  useRef + inputRef.current.focus()
// - isValid (computed property) ≈  render içinde türetilen değer, ayrı state tutulmaz

#Preview {
    NavigationStack { FormLab(savedWorkouts: .constant([])) }
}
