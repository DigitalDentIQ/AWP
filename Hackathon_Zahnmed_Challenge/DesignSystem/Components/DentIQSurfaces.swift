import SwiftUI

/// Kapitel-/Ergebnisfläche: Navy, große Hintergrundziffer, weißer Titel, Teal-Linie.
struct DentIQChapterPanel: View {
    let numeral: String
    let eyebrow: String
    let title: String
    var text: String?

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.large, style: .continuous)
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Text(numeral)
                .font(DentIQ.Font.numeral)
                .foregroundStyle(DentIQ.Color.inverseNumeral)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: DentIQ.Spacing.m) {
                EyebrowLabel(eyebrow)
                Text(title)
                    .font(DentIQ.Font.screenTitle)
                    .foregroundStyle(DentIQ.Color.onInverse)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityAddTraits(.isHeader)
                AccentLine()
                if let text {
                    Text(text)
                        .font(DentIQ.Font.body)
                        .foregroundStyle(DentIQ.Color.onInverseMuted)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(DentIQ.Spacing.l + DentIQ.Spacing.xs)
        .background(shape.fill(DentIQ.Color.surfaceInverse))
        .dentIQElevation(in: shape)
    }
}

/// Eingabefeld-Kapsel: Clinical-White-Fläche, bei Fokus Teal-Rahmen.
struct DentIQInputFrame: ViewModifier {
    let isFocused: Bool

    func body(content: Content) -> some View {
        content
            .font(DentIQ.Font.body)
            .foregroundStyle(DentIQ.Color.textPrimary)
            .padding(.horizontal, DentIQ.Spacing.l - DentIQ.Spacing.xs)
            .frame(minHeight: DentIQ.Spacing.buttonHeight)
            .background(Capsule().fill(DentIQ.Color.surface))
            .overlay(
                Capsule().strokeBorder(
                    isFocused ? DentIQ.Color.accent : DentIQ.Color.hairline.opacity(0.6),
                    lineWidth: isFocused ? 1.5 : DentIQ.Spacing.hairline
                )
            )
            .animation(.easeOut(duration: 0.2), value: isFocused)
    }
}

extension View {
    /// Kapsel-Rahmen für Textfelder; `isFocused` färbt ihn Teal.
    func dentIQInputFrame(isFocused: Bool) -> some View {
        modifier(DentIQInputFrame(isFocused: isFocused))
    }
}
