import SwiftUI
import UIKit

/// Namensraum für das Digital-DentIQ-Designsystem.
/// Views verwenden ausschließlich `DentIQ.Color`, `DentIQ.Font` und `DentIQ.Spacing`,
/// niemals Hex-Werte, `Color.blue` & Co. oder `Font.system(size:)`.
enum DentIQ {}

// MARK: - Palette (CI-Rohwerte)

extension DentIQ {
    /// Die 10 verbindlichen CI-Farben aus der Präsentationsvorlage, plus abgeleitete Werte.
    /// Nur innerhalb von `DesignSystem/` verwenden. Views nehmen die semantischen Tokens in `DentIQ.Color`.
    enum Palette {
        // CI (verbindlich)
        static let navy          = UIColor(hex: 0x102238)
        static let teal          = UIColor(hex: 0x189490)
        static let softMint      = UIColor(hex: 0xE6F3F2)
        static let clinicalWhite = UIColor(hex: 0xF4F8F9)
        static let white         = UIColor(hex: 0xFFFFFF)
        static let textSecondary = UIColor(hex: 0x566774)
        static let textMuted     = UIColor(hex: 0x8BA0AC)
        static let hairline      = UIColor(hex: 0xCCDDE1)
        static let navySoft      = UIColor(hex: 0x294355) // nur auf Navy
        static let onNavyMuted   = UIColor(hex: 0xB9CCD3) // nur auf Navy

        // NICHT Teil der CI – klares Rot für falsche Antworten (04.11.2026), 5,6:1 auf Weiß
        static let error         = UIColor(hex: 0xC62828)

        // NICHT Teil der CI – abgeleitet für Dark Mode (04.11.2026: Grund minimal blaugrauer, Karte helleres Teal)
        static let darkBackground    = UIColor(hex: 0x15273A) // Navy, minimal ins Blaugraue
        static let darkSurface       = UIColor(hex: 0x1F3447) // Karten/Sekundärflächen
        static let darkSurfaceAccent = UIColor(hex: 0x1E4F57) // Soft-Mint-Rolle: helleres Teal, Weiß 9,1:1
        static let darkHairline      = UIColor(hex: 0x2C4558)
        static let darkTeal          = UIColor(hex: 0x2BB3AD) // Teal aufgehellt: 5,9:1 auf Grund
        static let darkError         = UIColor(hex: 0xFF6B6B) // Rot aufgehellt: 5,5:1 auf Grund
        static let darkNavyNumeral   = UIColor(hex: 0x3A5870) // große Hintergrundziffer auf navySoft

        /// Haupttextfarbe als UIKit-Farbe (für Navigationsleisten-Appearance), hell Navy, dunkel Weiß.
        static let textPrimaryDynamic = UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0x102238)
        }

        // NICHT Teil der CI – Varianten für „Kontrast erhöhen“ (Apple HIG: eigene Farben brauchen sie)
        static let tealHighContrast      = UIColor(hex: 0x0E6E6A) // 6,1:1 auf Weiß
        static let darkTealHighContrast  = UIColor(hex: 0x5CD0C9) // 8,2:1 auf Grund
        static let hairlineHighContrast  = UIColor(hex: 0x8BA0AC)
        static let darkHairlineHighContrast = UIColor(hex: 0x4A6478)
    }
}

// MARK: - Semantische Farb-Tokens

extension DentIQ {
    /// Farben nach Aufgabe benannt. Jede hat eine Variante für Light (CI) und Dark (abgeleitet).
    enum Color {
        // Flächen
        /// Standard-Hintergrund eines Screens. Light: Weiß · Dark: Navy (blaugrau)
        static let background       = dynamic(light: Palette.white, dark: Palette.darkBackground)
        /// Sekundärflächen: Platzhalter, Bildflächen, Zebra-Zeilen. Light: Clinical White
        static let surface          = dynamic(light: Palette.clinicalWhite, dark: Palette.darkSurface)
        /// Ruhige Hervorhebung: Karten, Kernaussagen, Hero. Light: Soft Mint · Dark: helles Teal
        static let surfaceAccent    = dynamic(light: Palette.softMint, dark: Palette.darkSurfaceAccent)
        /// Dunkle Fläche: Tabellenkopf, Kapitel-/Ergebnis-Screens. Light: Navy · Dark: Navy Soft
        static let surfaceInverse   = dynamic(light: Palette.navy, dark: Palette.navySoft)

        // Gruppierte Seiten (wie Apples „grouped“-Stil): leicht getönter Grund, Karten heben sich ab
        /// Seitengrund unter Karten. Light: Clinical White · Dark: Navy (blaugrau)
        static let groupedBackground = dynamic(light: Palette.clinicalWhite, dark: Palette.darkBackground)
        /// Karten auf `groupedBackground`. Light: Weiß · Dark: etwas heller als der Grund
        static let groupedSurface    = dynamic(light: Palette.white, dark: Palette.darkSurface)

        // Text
        /// Haupttext und Überschriften. Light: Navy
        static let textPrimary      = dynamic(light: Palette.navy, dark: Palette.white)
        /// Fließtext, Untertitel, Beschreibungen. Light: #566774 (5,9:1)
        static let textSecondary    = dynamic(light: Palette.textSecondary, dark: Palette.onNavyMuted)
        /// Footer, Hilfstexte, Platzhalter. Nur 2,7:1 auf Weiß → nie für wichtige Inhalte.
        /// Bei „Kontrast erhöhen“ wird daraus `textSecondary`.
        static let textMuted        = dynamic(
            light: Palette.textMuted, dark: Palette.textMuted,
            lightHighContrast: Palette.textSecondary, darkHighContrast: Palette.onNavyMuted
        )

        // Auf dunkler Fläche (`surfaceInverse`)
        static let onInverse        = SwiftUI.Color(uiColor: Palette.white)
        static let onInverseMuted   = SwiftUI.Color(uiColor: Palette.onNavyMuted)
        /// Große Hintergrundziffer auf `surfaceInverse`.
        static let inverseNumeral   = dynamic(light: Palette.navySoft, dark: Palette.darkNavyNumeral)

        // Akzent & Status
        /// Einziger Akzent: Eyebrows, Nummern, Kennzahlen, Linien, Icons, aktive Elemente, Erfolg.
        /// Light 3,7:1 auf Weiß → nur große/fette Schrift, Icons, Linien, Flächen.
        static let accent           = dynamic(
            light: Palette.teal, dark: Palette.darkTeal,
            lightHighContrast: Palette.tealHighContrast, darkHighContrast: Palette.darkTealHighContrast
        )
        /// Fehler / falsche Antwort. NICHT Teil der CI.
        static let error            = dynamic(light: Palette.error, dark: Palette.darkError)

        // Linien
        /// 1-pt-Trennlinien und Rahmen.
        static let hairline         = dynamic(
            light: Palette.hairline, dark: Palette.darkHairline,
            lightHighContrast: Palette.hairlineHighContrast, darkHighContrast: Palette.darkHairlineHighContrast
        )

        /// Beschriftung heller Buttons auf `surfaceInverse` (immer Navy).
        static let onInverseButtonLabel = SwiftUI.Color(uiColor: Palette.navy)

        // Primär-Button
        static let buttonPrimary    = dynamic(light: Palette.navy, dark: Palette.clinicalWhite)
        static let onButtonPrimary  = dynamic(light: Palette.white, dark: Palette.navy)

        // Diagramme: Serie 1 Navy, Serie 2 Teal, weitere Abstufungen
        static let chartSeries: [SwiftUI.Color] = [
            dynamic(light: Palette.navy, dark: Palette.white),
            accent,
            textMuted,
        ]

        private static func dynamic(
            light: UIColor,
            dark: UIColor,
            lightHighContrast: UIColor? = nil,
            darkHighContrast: UIColor? = nil
        ) -> SwiftUI.Color {
            SwiftUI.Color(uiColor: UIColor { traits in
                let isDark = traits.userInterfaceStyle == .dark
                let isHighContrast = traits.accessibilityContrast == .high
                switch (isDark, isHighContrast) {
                case (false, false): return light
                case (true, false): return dark
                case (false, true): return lightHighContrast ?? light
                case (true, true): return darkHighContrast ?? dark
                }
            })
        }
    }
}

// MARK: - Hex-Helfer (nur für die Palette)

private extension UIColor {
    convenience init(hex: UInt32) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: 1
        )
    }
}
