import SwiftUI
import UIKit

extension DentIQ {
    /// Schriftrollen der CI. Alle wachsen mit Dynamic Type über `relativeTo:`.
    /// Manrope = Titel und Zahlen (leicht, nie fett). Plus Jakarta Sans = Text, Labels, Buttons.
    enum Font {
        /// Echte PostScript-Namen der eingebundenen TTFs (Resources/Fonts, Info.plist → UIAppFonts).
        enum Name: String, CaseIterable {
            case manropeLight     = "Manrope-Light"
            case manropeRegular   = "Manrope-Regular"
            case manropeMedium    = "Manrope-Medium"
            case jakartaRegular   = "PlusJakartaSans-Regular"
            case jakartaMedium    = "PlusJakartaSans-Medium"
            case jakartaBold      = "PlusJakartaSans-Bold"
        }

        // Manrope
        /// Titelseite / Onboarding. 40 pt Light.
        static let display     = custom(.manropeLight, 40, .largeTitle)
        /// Screen-Titel. 30 pt Regular.
        static let screenTitle = custom(.manropeRegular, 30, .largeTitle)
        /// Zwischenüberschrift. 22 pt Regular.
        static let heading     = custom(.manropeRegular, 22, .title2)
        /// Karten- und Abschnittstitel. 17 pt Medium.
        static let subheading  = custom(.manropeMedium, 17, .headline)
        /// Kennzahl (Punkte, Rang, Quote). 44 pt Regular, in Teal setzen.
        static let kpi         = custom(.manropeRegular, 44, .largeTitle)
        /// Große Hintergrundziffer auf Kapitel-/Ergebnisflächen. 96 pt Light.
        static let numeral     = custom(.manropeLight, 96, .largeTitle)

        // Plus Jakarta Sans
        /// Inhalt / Body. 17 pt Regular.
        static let body        = custom(.jakartaRegular, 17, .body)
        /// Betonung im Text. 17 pt Medium.
        static let bodyMedium  = custom(.jakartaMedium, 17, .body)
        /// Button-Beschriftung. 17 pt Medium.
        static let button      = custom(.jakartaMedium, 17, .body)
        /// Sekundärtext, Beschreibungen. 15 pt Regular.
        static let secondary   = custom(.jakartaRegular, 15, .subheadline)
        /// Kompakte Betonung, z. B. Antworten und Zeilentitel in Fall-Schritten. 15 pt Medium.
        static let secondaryMedium = custom(.jakartaMedium, 15, .subheadline)
        /// Eyebrow-Label (Versalien, Teal, Tracking über `EyebrowLabel`). 11 pt Bold.
        static let eyebrow     = custom(.jakartaBold, 11, .caption)
        /// Sektionsnummer „01“ und Tabellenkopf. 12 pt Bold.
        static let number      = custom(.jakartaBold, 12, .caption)
        /// Footer, Meta, Hilfstext. 11 pt Regular (iOS-Minimum).
        static let meta        = custom(.jakartaRegular, 11, .caption2)

        /// Monogramm-Buchstabe in Avataren. Feste Größe, weil der Kreis fest ist.
        static func monogram(_ size: CGFloat) -> SwiftUI.Font {
            .custom(Name.manropeMedium.rawValue, fixedSize: size)
        }

        /// Tracking für Eyebrow-Labels in pt.
        static let eyebrowTracking: CGFloat = 1.2

        private static func custom(_ name: Name, _ size: CGFloat, _ style: SwiftUI.Font.TextStyle) -> SwiftUI.Font {
            .custom(name.rawValue, size: size, relativeTo: style)
        }

        /// Debug-Check: Fällt eine Schrift still auf SF zurück, soll das sofort auffallen.
        /// Wird beim App-Start in Debug-Builds aufgerufen.
        static func verifyRegistration() {
            #if DEBUG
            let missing = Name.allCases.filter { UIFont(name: $0.rawValue, size: 12) == nil }
            if missing.isEmpty {
                print("✅ DentIQ-Schriften geladen: \(Name.allCases.map(\.rawValue).joined(separator: ", "))")
            } else {
                let families = UIFont.familyNames
                    .filter { $0.contains("Manrope") || $0.contains("Jakarta") }
                    .map { "\($0): \(UIFont.fontNames(forFamilyName: $0))" }
                print("❌ DentIQ-Schriften FEHLEN: \(missing.map(\.rawValue)). Gefunden: \(families)")
                assertionFailure("DentIQ-Schriften nicht geladen – Info.plist UIAppFonts und Target-Mitgliedschaft prüfen.")
            }
            #endif
        }
    }
}
