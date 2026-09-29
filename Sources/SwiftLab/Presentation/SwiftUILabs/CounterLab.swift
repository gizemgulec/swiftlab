import SwiftUI

public struct CounterLab: View {
    @State private var count = 0

    private var isEven: Bool { count % 2 == 0 }

    public init() {}

    public var body: some View {
        VStack(spacing: 24) {
            Text("\(count)")
                .font(.system(size: 72, weight: .bold))
                .foregroundStyle(isEven ? .blue : .orange)

            HStack(spacing: 16) {
                Button("−") { count -= 1 }
                    .disabled(count == 0)

                Button("+") { count += 1 }
            }
            .font(.largeTitle)
            .buttonStyle(.bordered)

            Button("Sıfırla", role: .destructive) { count = 0 }
        }
        .navigationTitle("Sayaç")
    }
}

// GÖREVLER:
// 1. Sayaç 10'a ulaşınca "Hedef!" yazısı göster
// 2. Artış miktarını seçmek için bir Stepper ekle (1, 5, 10)
// 3. Sayı değişirken .animation ile geçiş efekti ver

#Preview {
    NavigationStack { CounterLab() }
}