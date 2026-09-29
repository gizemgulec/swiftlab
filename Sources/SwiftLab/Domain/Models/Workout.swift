import Foundation

public struct Workout: Identifiable, Equatable, Sendable {
    public let id: UUID
    public var date: Date
    public var distance: Int
    public var duration: Int
    public var note: String

    public init(
        id: UUID = UUID(),
        date: Date,
        distance: Int,
        duration: Int,
        note: String
    ) {
        self.id = id
        self.date = date
        self.distance = distance
        self.duration = duration
        self.note = note
    }
}

public extension Workout {
    static let samples: [Workout] = [
        Workout(date: .now, distance: 5000, duration: 25, note: "Sakin tempo"),
        Workout(date: .now.addingTimeInterval(-86_400 * 2), distance: 2000, duration: 8, note: "Interval"),
        Workout(date: .now.addingTimeInterval(-86_400 * 4), distance: 8000, duration: 42, note: "")
    ]
}