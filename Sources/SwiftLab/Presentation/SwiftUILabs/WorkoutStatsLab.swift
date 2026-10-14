import Charts
import SwiftUI

public struct WorkoutStatsLab: View {
    @AppStorage("swiftlab.weeklyDistanceGoalMeters") private var weeklyGoalMeters = 20_000

    private let workouts: [Workout]

    public init(workouts: [Workout]) {
        self.workouts = workouts
    }

    private var statistics: WorkoutStatistics {
        WorkoutStatistics(workouts: workouts)
    }

    public var body: some View {
        let statistics = statistics

        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                goalSection(statistics: statistics)
                metricsSection(statistics: statistics)
                weeklyChart(statistics: statistics)
            }
            .padding()
        }
        .navigationTitle("İstatistikler")
    }

    private func goalSection(statistics: WorkoutStatistics) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Haftalık mesafe hedefi")
                .font(.headline)

            Stepper(value: $weeklyGoalMeters, in: 1_000...100_000, step: 1_000) {
                Text("\(kilometers(weeklyGoalMeters)) km")
                    .font(.title2.bold())
            }

            ProgressView(
                value: min(Double(statistics.weeklyDistance), Double(weeklyGoalMeters)),
                total: Double(weeklyGoalMeters)
            )
            .tint(.green)

            Text("\(kilometers(statistics.weeklyDistance)) / \(kilometers(weeklyGoalMeters)) km")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if statistics.weeklyDistance >= weeklyGoalMeters {
                Label("Haftalık hedef tamamlandı!", systemImage: "checkmark.circle.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.green)
            } else {
                Text("\(kilometers(weeklyGoalMeters - statistics.weeklyDistance)) km kaldı")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func metricsSection(statistics: WorkoutStatistics) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            metricCard(title: "Antrenman", value: "\(statistics.weeklyWorkoutCount)", symbol: "figure.run")
            metricCard(title: "Toplam süre", value: "\(statistics.weeklyDuration) dk", symbol: "clock")
            metricCard(
                title: "Ortalama tempo",
                value: statistics.averagePaceMinutesPerKilometer
                    .map { "\($0.formatted(.number.precision(.fractionLength(1)))) dk/km" } ?? "—",
                symbol: "speedometer"
            )
            metricCard(title: "Bu hafta", value: "\(kilometers(statistics.weeklyDistance)) km", symbol: "figure.run")
        }
    }

    private func metricCard(title: String, value: String, symbol: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: symbol)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3.bold())
                .minimumScaleFactor(0.8)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, minHeight: 76, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func weeklyChart(statistics: WorkoutStatistics) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Haftalık mesafe")
                .font(.headline)

            if statistics.weeklyWorkoutCount == 0 {
                VStack(spacing: 8) {
                    Image(systemName: "chart.bar")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("Bu hafta antrenman yok")
                        .font(.headline)
                    Text("Antrenman eklediğinizde haftalık grafik burada görünür.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, minHeight: 200)
            } else {
                Chart(statistics.dailyDistances) { day in
                    BarMark(
                        x: .value("Gün", day.date, unit: .day),
                        y: .value("Mesafe", Double(day.distance) / 1_000)
                    )
                    .foregroundStyle(.blue.gradient)
                }
                .chartYAxisLabel("km")
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { _ in
                        AxisValueLabel(format: .dateTime.weekday(.narrow))
                    }
                }
                .frame(height: 220)
                .accessibilityLabel("Bu haftanın günlük antrenman mesafeleri")
            }
        }
    }

    private func kilometers(_ meters: Int) -> String {
        (Double(meters) / 1_000).formatted(.number.precision(.fractionLength(0...1)))
    }
}

#Preview {
    NavigationStack {
        WorkoutStatsLab(workouts: Workout.samples)
    }
}
