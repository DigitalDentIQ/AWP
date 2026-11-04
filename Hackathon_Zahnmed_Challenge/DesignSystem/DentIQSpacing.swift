import SwiftUI

extension DentIQ {
    /// Abstände und Linien.
    enum Spacing {
        /// Seitenrand links/rechts auf iPhone (CI: ca. 5 % der Breite).
        static let margin: CGFloat = 24

        static let xs: CGFloat = 4
        static let s: CGFloat = 8
        static let m: CGFloat = 16
        static let l: CGFloat = 24
        static let xl: CGFloat = 40

        /// Stärke der Hairline-Trennlinie.
        static let hairline: CGFloat = 1
        /// Kurze Teal-Akzentlinie über Titeln/Karten.
        static let accentLineWidth: CGFloat = 40
        static let accentLineHeight: CGFloat = 2

        /// Standard-Tapfläche nach Apple HIG (44 × 44 pt).
        static let minTapTarget: CGFloat = 44
        /// Höhe von Primär-/Sekundär-Buttons.
        static let buttonHeight: CGFloat = 52
    }

    /// Eckenradien. Immer mit `.continuous` (Apples weiche „Squircle“-Kurve).
    /// Innere Elemente sind konzentrisch: innerer Radius = äußerer Radius − Innenabstand.
    /// Abweichung von der CI (dort eckig): freigegeben am 04.11.2026 für ein ruhigeres, hochwertigeres Gefühl.
    enum Radius {
        /// Große Flächen: Kapitel-/Ergebnisfläche, Hero.
        static let large: CGFloat = 28
        /// Karten.
        static let card: CGFloat = 24
        /// Tabellen und gruppierte Listen.
        static let group: CGFloat = 20
        /// Symbol-Kacheln (z. B. Fall-Symbol in Listen).
        static let tile: CGFloat = 14
        /// Elemente in Karten (Bildflächen), konzentrisch zu `card` mit 16 pt Innenabstand.
        static let inner: CGFloat = 8
        /// Kleine Elemente: Marker, Tags.
        static let small: CGFloat = 6
    }
}

// MARK: - Erhöhung (Schatten / Licht)

/// Hebt eine Fläche dezent ab.
/// Hell: zwei weiche Schatten (Umgebung + Licht von oben), kaum sichtbar.
/// Dunkel: Schatten wirken dort nicht, stattdessen eine feine helle Kante.
struct DentIQElevation<S: InsettableShape>: ViewModifier {
    let shape: S
    @Environment(\.colorScheme) private var colorScheme

    @ViewBuilder
    func body(content: Content) -> some View {
        if colorScheme == .dark {
            content
                .overlay(shape.strokeBorder(Color.white.opacity(0.07), lineWidth: DentIQ.Spacing.hairline))
        } else {
            content
                .shadow(color: Color(uiColor: DentIQ.Palette.navy).opacity(0.04), radius: 2, y: 1)
                .shadow(color: Color(uiColor: DentIQ.Palette.navy).opacity(0.07), radius: 24, y: 12)
        }
    }
}

extension View {
    /// Dezente Erhöhung für Karten und hervorgehobene Flächen.
    func dentIQElevation<S: InsettableShape>(in shape: S) -> some View {
        modifier(DentIQElevation(shape: shape))
    }
}
