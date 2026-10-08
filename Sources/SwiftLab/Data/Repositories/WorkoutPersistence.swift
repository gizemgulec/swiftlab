import Foundation

enum WorkoutPersistence {
    private static let storageKey = "swiftlab.workouts"

    static func load(from defaults: UserDefaults = .standard) throws -> [Workout]? {
        guard let data = defaults.data(forKey: storageKey) else { return nil }
        return try JSONDecoder().decode([Workout].self, from: data)
    }

    static func save(_ workouts: [Workout], to defaults: UserDefaults = .standard) throws {
        let data = try JSONEncoder().encode(workouts)
        defaults.set(data, forKey: storageKey)
    }
}
