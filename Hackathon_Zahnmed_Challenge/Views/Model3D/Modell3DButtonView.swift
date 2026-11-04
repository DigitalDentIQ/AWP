import SwiftUI

// ─────────────────────────────────────────────
// MARK: - BUTTON auf der Startseite
// ─────────────────────────────────────────────

struct Modell3DButtonView: View {
    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.group, style: .continuous)
    }

    var body: some View {
        HStack(spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs) {
            Image(systemName: "rotate.3d")
                .font(.title3)
                .foregroundStyle(DentIQ.Color.accent)
                .frame(width: DentIQ.Spacing.minTapTarget, height: DentIQ.Spacing.minTapTarget)
                .background(
                    RoundedRectangle(cornerRadius: DentIQ.Radius.tile, style: .continuous)
                        .fill(DentIQ.Color.surfaceAccent)
                )
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text("3D Modelle ansehen")
                    .font(DentIQ.Font.subheading)
                    .foregroundStyle(DentIQ.Color.textPrimary)
                Text("Ausgangsbefund · Fehlerhaft · Korrekt")
                    .font(DentIQ.Font.meta)
                    .foregroundStyle(DentIQ.Color.textSecondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(DentIQ.Color.textMuted)
                .accessibilityHidden(true)
        }
        .padding(DentIQ.Spacing.m - DentIQ.Spacing.xs)
        .background(shape.fill(DentIQ.Color.groupedSurface))
        .dentIQElevation(in: shape)
    }
}
