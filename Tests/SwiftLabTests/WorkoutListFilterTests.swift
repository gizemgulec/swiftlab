import XCTest
@testable import SwiftLab

final class WorkoutListFilterTests: XCTestCase {
    func testSearchMatchesNotesCaseInsensitivelyAndDistances() {
        let workouts = [
            makeWorkout(daysAgo: 1, distance: 5000, note: "Tempo run"),
            makeWorkout(daysAgo: 2, distance: 8000, note: "Easy"),
            makeWorkout(daysAgo: 3, distance: 3000, note: "Recovery")
        ]
        let now = Date(timeIntervalSince1970: 1_800_000_000)

        let noteMatches = WorkoutListFilter(query: "TEMPO").apply(to: workouts, now: now)
        let distanceMatches = WorkoutListFilter(query: "8000").apply(to: workouts, now: now)

        XCTAssertEqual(noteMatches.map(\.note), ["Tempo run"])
        XCTAssertEqual(distanceMatches.map(\.distance), [8000])
    }

    func testPeriodFilterCanBeCombinedWithSearchAndSortsNewestFirst() {
        let workouts = [
            makeWorkout(daysAgo: 8, distance: 5000, note: "Tempo"),
            makeWorkout(daysAgo: 2, distance: 5000, note: "Tempo"),
            makeWorkout(daysAgo: 1, distance: 3000, note: "Easy")
        ]
        let now = Date(timeIntervalSince1970: 1_800_000_000)
        let filter = WorkoutListFilter(query: "tempo", period: .week)

        let results = filter.apply(to: workouts, now: now)

        XCTAssertEqual(results.map(\.note), ["Tempo"])
        XCTAssertEqual(results.map(\.distance), [5000])
    }

    func testMonthPeriodIncludesWorkoutsWithinThirtyDays() {
        let workouts = [
            makeWorkout(daysAgo: 31, distance: 5000, note: "Old"),
            makeWorkout(daysAgo: 30, distance: 4000, note: "Recent")
        ]
        let now = Date(timeIntervalSince1970: 1_800_000_000)

        let results = WorkoutListFilter(period: .month).apply(to: workouts, now: now)

        XCTAssertEqual(results.map(\.note), ["Recent"])
    }

    private func makeWorkout(daysAgo: Int, distance: Int, note: String) -> Workout {
        Workout(
            date: Date(timeIntervalSince1970: 1_800_000_000 - Double(daysAgo * 86_400)),
            distance: distance,
            duration: 30,
            note: note
        )
    }
}
