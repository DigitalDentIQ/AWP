import SwiftUI

// ─────────────────────────────────────────────
// MARK: - MODELL-KARTE
// ─────────────────────────────────────────────

struct ModellKarteView: View {
    let modell: ZahnModell

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.group, style: .continuous)
    }

    var body: some View {
        HStack(spacing: DentIQ.Spacing.m) {
            Image(systemName: modell.icon)
                .font(.title2)
                .foregroundStyle(modell.art.tint)
                .frame(width: 52, height: 52)
                .background(Circle().fill(modell.art.tint.opacity(0.12)))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: DentIQ.Spacing.xs) {
                Text(modell.name)
                    .font(DentIQ.Font.subheading)
                    .foregroundStyle(DentIQ.Color.textPrimary)
                Text(modell.beschreibung)
                    .font(DentIQ.Font.secondary)
                    .foregroundStyle(DentIQ.Color.textSecondary)
                Label("3D Modell ansehen", systemImage: "cube")
                    .font(DentIQ.Font.meta)
                    .foregroundStyle(DentIQ.Color.accent)
                    .padding(.top, 2)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(DentIQ.Color.textMuted)
                .accessibilityHidden(true)
        }
        .padding(DentIQ.Spacing.m)
        .background(shape.fill(DentIQ.Color.groupedSurface))
        .dentIQElevation(in: shape)
        .accessibilityElement(children: .combine)
    }
}
