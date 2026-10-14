import XCTest
@testable import SwiftLab

final class WorkoutStatisticsTests: XCTestCase {
    func testStatisticsIncludeCurrentWeekAndExcludePreviousAndFutureWorkouts() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        calendar.firstWeekday = 2
        let now = try date(year: 2026, month: 1, day: 7, hour: 12, calendar: calendar)
        let workouts = [
            Workout(date: try date(year: 2026, month: 1, day: 5, hour: 9, calendar: calendar), distance: 4_000, duration: 20, note: ""),
            Workout(date: try date(year: 2026, month: 1, day: 7, hour: 8, calendar: calendar), distance: 6_000, duration: 30, note: ""),
            Workout(date: try date(year: 2026, month: 1, day: 4, hour: 9, calendar: calendar), distance: 10_000, duration: 50, note: ""),
            Workout(date: try date(year: 2026, month: 1, day: 8, hour: 9, calendar: calendar), distance: 8_000, duration: 40, note: "")
        ]

        let statistics = WorkoutStatistics(workouts: workouts, now: now, calendar: calendar)

        XCTAssertEqual(statistics.weeklyDistance, 10_000)
        XCTAssertEqual(statistics.weeklyDuration, 50)
        XCTAssertEqual(statistics.weeklyWorkoutCount, 2)
        XCTAssertEqual(statistics.averagePaceMinutesPerKilometer, 5)
        XCTAssertEqual(statistics.dailyDistances.count, 7)
        XCTAssertEqual(statistics.dailyDistances[0].distance, 4_000)
        XCTAssertEqual(statistics.dailyDistances[2].distance, 6_000)
    }

    func testPaceIsNilWhenThereIsNoDistanceThisWeek() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let now = try date(year: 2026, month: 1, day: 7, hour: 12, calendar: calendar)
        let previousWeek = try date(year: 2026, month: 1, day: 1, hour: 12, calendar: calendar)
        let statistics = WorkoutStatistics(
            workouts: [Workout(date: previousWeek, distance: 5_000, duration: 25, note: "")],
            now: now,
            calendar: calendar
        )

        XCTAssertEqual(statistics.weeklyDistance, 0)
        XCTAssertNil(statistics.averagePaceMinutesPerKilometer)
    }

    private func date(
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        calendar: Calendar
    ) throws -> Date {
        let components = DateComponents(year: year, month: month, day: day, hour: hour)
        guard let date = calendar.date(from: components) else {
            throw DateError.invalidComponents
        }
        return date
    }

    private enum DateError: Error {
        case invalidComponents
    }
}
