import SwiftUI

// MARK: - Option State
/// Zustand einer Antwort-Option. Richtig = Teal, falsch oder vergessen = Rot (nicht CI).
/// Immer zusammen mit Symbol (Häkchen/Kreuz), nie nur über Farbe.
enum OptionState {
    /// `missed`: richtige Antwort, die nicht angekreuzt wurde.
    case idle, selected, correct, wrong, missed

    var background: Color {
        switch self {
        case .idle:     DentIQ.Color.groupedSurface
        case .selected: DentIQ.Color.surfaceAccent
        case .correct:  DentIQ.Color.surfaceAccent
        case .wrong, .missed: DentIQ.Color.error.opacity(0.1)
        }
    }

    var border: Color {
        switch self {
        case .idle:     DentIQ.Color.hairline
        case .selected: DentIQ.Color.accent
        case .correct:  DentIQ.Color.accent
        case .wrong, .missed: DentIQ.Color.error
        }
    }

    /// Farbe für Symbole und Markierungen.
    var accent: Color {
        switch self {
        case .idle:     DentIQ.Color.textMuted
        case .selected, .correct: DentIQ.Color.accent
        case .wrong, .missed: DentIQ.Color.error
        }
    }

    var text: Color { DentIQ.Color.textPrimary }

    var isHighlighted: Bool { self != .idle }
}
