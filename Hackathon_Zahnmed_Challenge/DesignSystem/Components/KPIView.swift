import SwiftUI

/// Kennzahl: große Teal-Zahl in Manrope, Label, Hairline, optionale Quellenzeile.
/// Für Punkte, Rang, Quote.
struct KPIView: View {
    let value: String
    let label: String
    var caption: String?
    /// Ausrichtung von Zahl und Text, z. B. `.center` für nebeneinanderstehende Kennzahlen.
    var alignment: HorizontalAlignment = .leading

    private var frameAlignment: Alignment {
        alignment == .center ? .center : (alignment == .trailing ? .trailing : .leading)
    }

    var body: some View {
        VStack(alignment: alignment, spacing: DentIQ.Spacing.s) {
            Text(value)
                .font(DentIQ.Font.kpi)
                .foregroundStyle(DentIQ.Color.accent)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(label)
                .font(DentIQ.Font.bodyMedium)
                .foregroundStyle(DentIQ.Color.textPrimary)
            HairlineDivider()
            if let caption {
                Text(caption)
                    .font(DentIQ.Font.meta)
                    .foregroundStyle(DentIQ.Color.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: frameAlignment)
        .accessibilityElement(children: .combine)
    }
}
