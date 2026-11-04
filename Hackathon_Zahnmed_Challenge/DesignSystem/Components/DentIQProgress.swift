import SwiftUI

/// Prozess-/Roadmap-Darstellung: feine Linie mit runden Markern.
/// Erledigt = Teal mit weißer Nummer, aktuell = Teal mit Ring, offen = Hairline-Kreis.
struct ProgressSteps: View {
    /// Aktueller Schritt, 1-basiert.
    let current: Int
    let total: Int

    @ScaledMetric(relativeTo: .caption2) private var markerSize: CGFloat = 22

    var body: some View {
        HStack(spacing: 0) {
            ForEach(1...max(total, 1), id: \.self) { step in
                HStack(spacing: 0) {
                    marker(for: step)
                    if step < total {
                        Capsule()
                            .fill(step < current ? DentIQ.Color.accent : DentIQ.Color.hairline)
                            .frame(height: DentIQ.Spacing.accentLineHeight)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, DentIQ.Spacing.xs)
                    }
                }
            }
        }
        .padding(.vertical, DentIQ.Spacing.xs)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Schritt \(current) von \(total)")
    }

    private func marker(for step: Int) -> some View {
        let reached = step <= current
        return Text("\(step)")
            .font(DentIQ.Font.meta)
            .monospacedDigit()
            .foregroundStyle(reached ? DentIQ.Color.onInverse : DentIQ.Color.textMuted)
            .frame(width: markerSize, height: markerSize)
            .background(Circle().fill(reached ? DentIQ.Color.accent : DentIQ.Color.background))
            .overlay(Circle().strokeBorder(reached ? Color.clear : DentIQ.Color.hairline, lineWidth: DentIQ.Spacing.hairline))
            .overlay(
                // Aktueller Schritt bekommt einen feinen Ring
                Circle()
                    .strokeBorder(DentIQ.Color.accent.opacity(0.35), lineWidth: step == current ? 3 : 0)
                    .padding(-4)
            )
    }
}

/// Schlanker Fortschrittsbalken mit runden Enden (z. B. in Fallkarten).
struct DentIQProgressBar: View {
    /// 0…1
    let value: Double

    private var clamped: Double { min(max(value, 0), 1) }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(DentIQ.Color.hairline)
                Capsule()
                    .fill(DentIQ.Color.accent)
                    .frame(width: geo.size.width * clamped)
            }
        }
        .frame(height: 4)
        .accessibilityElement()
        .accessibilityValue(Text("\(Int((clamped * 100).rounded())) Prozent"))
    }
}
