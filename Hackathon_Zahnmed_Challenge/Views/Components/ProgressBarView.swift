import SwiftUI

// MARK: - REUSABLE: Progress Bar
/// Fortschritt im Fall: „Schritt x von y“, bisher gesammelte Punkte und schlanker Teal-Balken.
struct ProgressBarView: View {
    let step: Int
    let total: Int
    /// Summe aller Punkte im aktuellen Durchlauf.
    let points: Int

    var body: some View {
        VStack(spacing: DentIQ.Spacing.s) {
            HStack {
                Text("Schritt \(step) von \(total)")
                    .font(DentIQ.Font.secondaryMedium)
                    .foregroundStyle(DentIQ.Color.textPrimary)
                Spacer()
                Text("\(points) Punkte")
                    .font(DentIQ.Font.number)
                    .monospacedDigit()
                    .foregroundStyle(points > 0 ? DentIQ.Color.accent : DentIQ.Color.textSecondary)
                    .contentTransition(.numericText(value: Double(points)))
                    .animation(.snappy, value: points)
            }
            DentIQProgressBar(value: Double(step) / Double(max(total, 1)))
        }
        .padding(.horizontal, DentIQ.Spacing.m)
    }
}
