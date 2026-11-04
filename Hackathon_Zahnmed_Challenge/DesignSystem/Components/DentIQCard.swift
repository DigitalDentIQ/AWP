import SwiftUI

/// Ruhige Fläche mit weichen Ecken für hervorgehobene Inhalte.
struct DentIQCard<Content: View>: View {
    enum Style {
        /// Soft Mint (dunkel: helles Teal): Kernaussage, Hero, Kennzahl-Karten.
        case accent
        /// Clinical White: Bildflächen, Platzhalter, Nebeninhalte.
        case surface
        /// Hintergrundfarbe mit Hairline-Rahmen: neutrale Karte ohne Farbfläche.
        case outlined
    }

    var style: Style = .accent
    /// Kurze Teal-Linie oben in der Karte.
    var showsAccentLine: Bool = false
    @ViewBuilder let content: () -> Content

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.card, style: .continuous)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DentIQ.Spacing.m) {
            if showsAccentLine {
                AccentLine()
            }
            content()
        }
        .padding(DentIQ.Spacing.l)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(background)
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .accent:
            shape.fill(DentIQ.Color.surfaceAccent).dentIQElevation(in: shape)
        case .surface:
            shape.fill(DentIQ.Color.surface).dentIQElevation(in: shape)
        case .outlined:
            shape.fill(DentIQ.Color.background)
                .overlay(shape.strokeBorder(DentIQ.Color.hairline, lineWidth: DentIQ.Spacing.hairline))
        }
    }
}
