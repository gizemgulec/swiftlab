import Foundation

public struct Workout: Identifiable, Equatable, Codable, Sendable {
    public enum Intensity: String, CaseIterable, Codable, Identifiable, Sendable {
        case easy = "Sakin"
        case steady = "Tempo"
        case interval = "Interval"

        public var id: Self { self }
    }

    public let id: UUID
    public var date: Date
    public var distance: Int
    public var duration: Int
    public var intensity: Intensity
    public var note: String

    public init(
        id: UUID = UUID(),
        date: Date,
        distance: Int,
        duration: Int,
        intensity: Intensity = .easy,
        note: String
    ) {
        self.id = id
        self.date = date
        self.distance = distance
        self.duration = duration
        self.intensity = intensity
        self.note = note
    }

    private enum CodingKeys: String, CodingKey {
        case id, date, distance, duration, intensity, note
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        distance = try container.decode(Int.self, forKey: .distance)
        duration = try container.decode(Int.self, forKey: .duration)
        let storedNote = try container.decode(String.self, forKey: .note)

        if let storedIntensity = try container.decodeIfPresent(Intensity.self, forKey: .intensity) {
            intensity = storedIntensity
            note = storedNote
        } else if let legacyWorkout = Self.migrateLegacyNote(storedNote) {
            intensity = legacyWorkout.intensity
            note = legacyWorkout.note
        } else {
            intensity = .easy
            note = storedNote
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(distance, forKey: .distance)
        try container.encode(duration, forKey: .duration)
        try container.encode(intensity, forKey: .intensity)
        try container.encode(note, forKey: .note)
    }

    private static func migrateLegacyNote(_ note: String) -> (intensity: Intensity, note: String)? {
        for intensity in Intensity.allCases {
            if note == intensity.rawValue {
                return (intensity, "")
            }
            let prefix = "\(intensity.rawValue) – "
            if note.hasPrefix(prefix) {
                return (intensity, String(note.dropFirst(prefix.count)))
            }
        }
        return nil
    }
}

public extension Workout {
    static let samples: [Workout] = [
        Workout(date: .now, distance: 5000, duration: 25, intensity: .easy, note: "Sakin tempo"),
        Workout(date: .now.addingTimeInterval(-86_400 * 2), distance: 2000, duration: 8, intensity: .interval, note: "Interval"),
        Workout(date: .now.addingTimeInterval(-86_400 * 4), distance: 8000, duration: 42, note: "")
    ]
}