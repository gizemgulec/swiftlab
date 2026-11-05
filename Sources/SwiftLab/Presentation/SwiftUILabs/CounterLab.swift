import SwiftUI

public struct CounterLab: View {
    @AppStorage("swiftlab.counterLab.count") private var count = 0
    @State private var stepIndex = 0
    @State private var previousCount: Int?
    @State private var isShowingResetConfirmation = false
    @AppStorage("swiftlab.counterLab.goal") private var goal = 10

    private let steps = [1, 5, 10]

    private var isEven: Bool { count % 2 == 0 }
    private var step: Int { steps[stepIndex] }
    private var hasReachedGoal: Bool { count >= goal }
    private var progressCount: Int { min(max(count, 0), goal) }

    public init() {}

    public var body: some View {
        VStack(spacing: 24) {
            Text("\(count)")
                .font(.system(size: 72, weight: .bold))
                .foregroundStyle(isEven ? .blue : .orange)
                .contentTransition(.opacity)
                .animation(.spring(response: 0.35, dampingFraction: 0.7), value: count)

            VStack(spacing: 8) {
                Text("Hedefe ilerleme: \(progressCount) / \(goal)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ProgressView(value: Double(progressCount), total: Double(goal))
                    .accessibilityLabel("Hedefe ilerleme")
                    .accessibilityValue("\(progressCount) / \(goal)")
            }
            .padding(.horizontal)

            HStack(spacing: 16) {
                Button("−") { updateCount(to: max(0, count - step)) }
                    .disabled(count == 0)

                Button("+") { updateCount(to: count + step) }
            }
            .font(.largeTitle)
            .buttonStyle(.bordered)

            Button("Son işlemi geri al", systemImage: "arrow.uturn.backward") {
                guard let previousCount else { return }
                count = previousCount
                self.previousCount = nil
            }
            .buttonStyle(.bordered)
            .disabled(previousCount == nil)

            Stepper("Adım: \(step)", value: $stepIndex, in: 0...(steps.count - 1))
                .padding(.horizontal)

            Stepper("Hedef: \(goal)", value: $goal, in: 10...100, step: 10)
                .padding(.horizontal)

            if hasReachedGoal {
                Label("Hedefe ulaştın!", systemImage: "checkmark.circle.fill")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.green)
                    .transition(.scale.combined(with: .opacity))
            }

            Button("Sıfırla", role: .destructive) {
                isShowingResetConfirmation = true
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: hasReachedGoal)
        .confirmationDialog(
            "Sayacı sıfırlamak istiyor musun?",
            isPresented: $isShowingResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Sayacı Sıfırla", role: .destructive) { updateCount(to: 0) }
            Button("İptal", role: .cancel) {}
        }
        .navigationTitle("Sayaç")
    }

    private func updateCount(to newCount: Int) {
        previousCount = count
        count = newCount
    }
}

#Preview {
    NavigationStack { CounterLab() }
}
