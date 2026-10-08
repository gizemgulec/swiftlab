import Foundation
import XCTest
@testable import SwiftLab

final class WorkoutPersistenceTests: XCTestCase {
    func testLoadReturnsNilWhenThereAreNoSavedWorkouts() throws {
        let defaults = makeDefaults()

        XCTAssertNil(try WorkoutPersistence.load(from: defaults))
    }

    func testSaveAndLoadRoundTrip() throws {
        let defaults = makeDefaults()
        let workouts = [
            Workout(date: Date(timeIntervalSince1970: 1_700_000_000), distance: 5000, duration: 25, note: "Tempo")
        ]

        try WorkoutPersistence.save(workouts, to: defaults)

        XCTAssertEqual(try WorkoutPersistence.load(from: defaults), workouts)
    }

    func testSaveAndLoadPreservesAnEmptyList() throws {
        let defaults = makeDefaults()

        try WorkoutPersistence.save([], to: defaults)

        XCTAssertEqual(try WorkoutPersistence.load(from: defaults), [])
    }

    private func makeDefaults() -> UserDefaults {
        let suiteName = "WorkoutPersistenceTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }
}
