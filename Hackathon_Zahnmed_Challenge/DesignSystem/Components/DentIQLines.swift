import SwiftUI

/// Eyebrow-Label über Titeln: Versalien, Teal, Bold, leicht gesperrt. Format „BEREICH / UNTERBEREICH“.
/// Bewusste CI-Ausnahme beim Kontrast (kleine Teal-Schrift).
struct EyebrowLabel: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text.uppercased())
            .font(DentIQ.Font.eyebrow)
            .tracking(DentIQ.Font.eyebrowTracking)
            .foregroundStyle(DentIQ.Color.accent)
            .accessibilityLabel(text)
    }
}

/// Kurze Teal-Linie als Akzent über Titeln und Karten.
struct AccentLine: View {
    var body: some View {
        Rectangle()
            .fill(DentIQ.Color.accent)
            .frame(width: DentIQ.Spacing.accentLineWidth, height: DentIQ.Spacing.accentLineHeight)
            .accessibilityHidden(true)
    }
}

/// 1-pt-Trennlinie in Hairline-Farbe. Struktur entsteht durch Linien statt Boxen.
struct HairlineDivider: View {
    var body: some View {
        Rectangle()
            .fill(DentIQ.Color.hairline)
            .frame(height: DentIQ.Spacing.hairline)
            .frame(maxWidth: .infinity)
            .accessibilityHidden(true)
    }
}

/// Sektionsnummer „01“ mit Überschrift, für Listen und agenda-artige Strukturen.
struct SectionHeading: View {
    let number: String
    let title: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: DentIQ.Spacing.s) {
            Text(number)
                .font(DentIQ.Font.number)
                .foregroundStyle(DentIQ.Color.accent)
            Text(title)
                .font(DentIQ.Font.subheading)
                .foregroundStyle(DentIQ.Color.textPrimary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }
}
