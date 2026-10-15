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

    func testSaveAndLoadPreservesIntensity() throws {
        let defaults = makeDefaults()
        let workout = Workout(
            date: Date(timeIntervalSince1970: 1_700_000_000),
            distance: 5000,
            duration: 25,
            intensity: .interval,
            note: "Tekrarlar"
        )

        try WorkoutPersistence.save([workout], to: defaults)

        XCTAssertEqual(try WorkoutPersistence.load(from: defaults), [workout])
    }

    func testLoadMigratesLegacyIntensityPrefixFromNote() throws {
        let defaults = makeDefaults()
        let legacyWorkout = Workout(
            date: Date(timeIntervalSince1970: 1_700_000_000),
            distance: 5000,
            duration: 25,
            intensity: .steady,
            note: "Tempo – kontrollü koşu"
        )
        let data = try JSONEncoder().encode(legacyWorkout)
        let object = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: Any])
        let legacyObject = object.filter { $0.key != "intensity" }
        defaults.set(try JSONSerialization.data(withJSONObject: [legacyObject]), forKey: "swiftlab.workouts")

        let loaded = try XCTUnwrap(WorkoutPersistence.load(from: defaults)?.first)

        XCTAssertEqual(loaded.intensity, .steady)
        XCTAssertEqual(loaded.note, "kontrollü koşu")
    }

    private func makeDefaults() -> UserDefaults {
        let suiteName = "WorkoutPersistenceTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }
}
