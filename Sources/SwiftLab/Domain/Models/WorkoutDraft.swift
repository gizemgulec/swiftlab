import Foundation

public struct WorkoutDraft {
    public enum Intensity: String, CaseIterable, Identifiable {
        case easy = "Sakin"
        case steady = "Tempo"
        case interval = "Interval"

        public var id: Self { self }
    }

    public var date: Date
    public var distance: Int?
    public var duration: Int?
    public var intensity: Intensity
    public var hasNote: Bool
    public var note: String

    public init(
        date: Date = .now,
        distance: Int? = nil,
        duration: Int? = nil,
        intensity: Intensity = .easy,
        hasNote: Bool = false,
        note: String = ""
    ) {
        self.date = date
        self.distance = distance
        self.duration = duration
        self.intensity = intensity
        self.hasNote = hasNote
        self.note = note
    }

    public var isValid: Bool {
        guard let distance, let duration else { return false }
        return distance > 0 && duration > 0
    }
}
