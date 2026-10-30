import SwiftUI

public struct CounterLab: View {
    @AppStorage("swiftlab.counterLab.count") private var count = 0
    @State private var stepIndex = 0
    @State private var previousCount: Int?
    @AppStorage("swiftlab.counterLab.goal") private var goal = 10

    private let steps = [1, 5, 10]

    private var isEven: Bool { count % 2 == 0 }
    private var step: Int { steps[stepIndex] }
    private var hasReachedGoal: Bool { count >= goal }

    public init() {}

    public var body: some View {
        VStack(spacing: 24) {
            Text("\(count)")
                .font(.system(size: 72, weight: .bold))
                .foregroundStyle(isEven ? .blue : .orange)
                .contentTransition(.opacity)
                .animation(.spring(response: 0.35, dampingFraction: 0.7), value: count)

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

            Button("Sıfırla", role: .destructive) { updateCount(to: 0) }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: hasReachedGoal)
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
