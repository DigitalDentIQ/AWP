import SwiftUI

/// Primär-Button: Navy-Kapsel, weißer Text, volle Breite.
/// Drücken: leichtes Einsinken mit Feder-Animation und kurzer Haptik (ohne Bewegung bei „Bewegung reduzieren“).
/// Verwendung: `Button("Weiter") { … }.buttonStyle(.dentIQPrimary)`
struct DentIQPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        DentIQButtonBody(configuration: configuration, prominence: .primary)
    }
}

/// Sekundär-Button: Kapsel mit Hairline-Rahmen, Navy-Text.
struct DentIQSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        DentIQButtonBody(configuration: configuration, prominence: .secondary)
    }
}

/// Text-Button ohne Fläche, z. B. „Alle ansehen“. Teal ist hier Akzent, daher Medium-Schnitt.
struct DentIQLinkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DentIQ.Font.bodyMedium)
            .foregroundStyle(DentIQ.Color.accent)
            .frame(minHeight: DentIQ.Spacing.minTapTarget)
            .contentShape(Rectangle())
            .opacity(configuration.isPressed ? 0.55 : 1)
    }
}

// MARK: - Gemeinsamer Aufbau

/// Eigene View, damit Umgebungswerte (aktiv, Bewegung reduzieren) sauber gelesen werden.
private struct DentIQButtonBody: View {
    enum Prominence { case primary, secondary }

    let configuration: ButtonStyleConfiguration
    let prominence: Prominence

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        configuration.label
            .font(DentIQ.Font.button)
            .foregroundStyle(foreground)
            .frame(maxWidth: .infinity, minHeight: DentIQ.Spacing.buttonHeight)
            .padding(.horizontal, DentIQ.Spacing.l)
            .background(background)
            .contentShape(Capsule())
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.97 : 1)
            .opacity(configuration.isPressed && reduceMotion ? 0.8 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
            .sensoryFeedback(.impact(weight: .light), trigger: configuration.isPressed) { _, pressed in
                pressed && isEnabled
            }
    }

    private var foreground: Color {
        guard isEnabled else { return DentIQ.Color.textSecondary }
        return prominence == .primary ? DentIQ.Color.onButtonPrimary : DentIQ.Color.textPrimary
    }

    @ViewBuilder
    private var background: some View {
        switch prominence {
        case .primary:
            // Ausgegraut: sichtbare graue Fläche, auch auf getöntem Grund
            Capsule().fill(isEnabled ? DentIQ.Color.buttonPrimary : DentIQ.Color.hairline.opacity(0.7))
        case .secondary:
            Capsule()
                .fill(DentIQ.Color.background)
                .overlay(
                    Capsule().strokeBorder(
                        configuration.isPressed ? DentIQ.Color.accent : DentIQ.Color.hairline,
                        lineWidth: DentIQ.Spacing.hairline
                    )
                )
        }
    }
}

extension ButtonStyle where Self == DentIQPrimaryButtonStyle {
    static var dentIQPrimary: DentIQPrimaryButtonStyle { DentIQPrimaryButtonStyle() }
}

extension ButtonStyle where Self == DentIQSecondaryButtonStyle {
    static var dentIQSecondary: DentIQSecondaryButtonStyle { DentIQSecondaryButtonStyle() }
}

extension ButtonStyle where Self == DentIQLinkButtonStyle {
    static var dentIQLink: DentIQLinkButtonStyle { DentIQLinkButtonStyle() }
}
