import SwiftUI

extension ZahnModell.Art {
    /// Akzentfarbe nach Bedeutung: Befund Navy, fehlerhaft Rot, korrekt Teal.
    var tint: Color {
        switch self {
        case .befund: DentIQ.Color.textPrimary
        case .fehlerhaft: DentIQ.Color.error
        case .korrekt: DentIQ.Color.accent
        }
    }
}
