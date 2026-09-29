import SwiftUI

public struct ContentView: View {
    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                Section("Temeller") {
                    NavigationLink("01 · @State – Sayaç") { CounterLab() }
                    NavigationLink("02 · List – Antrenmanlar") { WorkoutListLab() }
                }
            }
            .navigationTitle("SwiftLab")
        }
    }
}

#Preview {
    ContentView()
}