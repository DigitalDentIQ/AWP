import SwiftUI

// MARK: - REUSABLE: ConfirmButton
/// Bestätigen-Button der Fall-Schritte im DentIQ-Primärstil (Navy-Kapsel, Text + Symbol).
/// Immer sichtbar; solange `enabled` false ist, ausgegraut.
struct ConfirmButton: View {
    let title: String
    let icon: String
    let enabled: Bool
    /// Läuft gerade etwas (z. B. KI-Auswertung)? Dann Ladeanzeige mit Titel.
    var isBusy: Bool = false
    let action: () -> Void

    var body: some View {
        Group {
            if isBusy {
                HStack(spacing: DentIQ.Spacing.s) {
                    ProgressView()
                    Text(title)
                }
                .font(DentIQ.Font.button)
                .foregroundStyle(DentIQ.Color.textSecondary)
                .frame(maxWidth: .infinity, minHeight: DentIQ.Spacing.buttonHeight)
                .background(Capsule().fill(DentIQ.Color.groupedSurface))
                .accessibilityElement(children: .combine)
            } else {
                // Immer sichtbar; solange nichts ausgewählt ist, ausgegraut
                Button(action: action) {
                    HStack(spacing: DentIQ.Spacing.s) {
                        Text(title)
                        Image(systemName: icon)
                    }
                }
                .buttonStyle(.dentIQPrimary)
                .disabled(!enabled)
            }
        }
        .padding(.horizontal, DentIQ.Spacing.m)
        .animation(.easeOut(duration: 0.2), value: enabled)
    }
}
