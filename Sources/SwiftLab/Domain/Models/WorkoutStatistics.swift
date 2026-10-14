import Foundation

public struct WorkoutStatistics: Sendable {
    public struct DailyDistance: Identifiable, Sendable {
        public let date: Date
        public let distance: Int

        public var id: Date { date }
    }

    public let weeklyDistance: Int
    public let weeklyDuration: Int
    public let weeklyWorkoutCount: Int
    public let averagePaceMinutesPerKilometer: Double?
    public let dailyDistances: [DailyDistance]

    public init(workouts: [Workout], now: Date = .now, calendar: Calendar = .current) {
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start
            ?? calendar.startOfDay(for: now)
        let currentWeek = workouts.filter { $0.date >= weekStart && $0.date <= now }

        weeklyDistance = currentWeek.reduce(0) { $0 + $1.distance }
        weeklyDuration = currentWeek.reduce(0) { $0 + $1.duration }
        weeklyWorkoutCount = currentWeek.count
        averagePaceMinutesPerKilometer = weeklyDistance > 0
            ? Double(weeklyDuration) / (Double(weeklyDistance) / 1_000)
            : nil

        let distancesByDay = Dictionary(grouping: currentWeek) {
            calendar.startOfDay(for: $0.date)
        }
        dailyDistances = (0..<7).compactMap { dayOffset in
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: weekStart) else {
                return nil
            }
            let day = calendar.startOfDay(for: date)
            let distance = distancesByDay[day, default: []]
                .reduce(0) { $0 + $1.distance }
            return DailyDistance(date: day, distance: distance)
        }
    }
}
