import SwiftUI

// MARK: - SEARCH BAR
/// Suchfeld auf der Startseite. Ein Tipp öffnet die Suche als Overlay.
struct SearchBarView: View {
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs) {
            Button(action: onTap) {
                HStack(spacing: DentIQ.Spacing.s) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(DentIQ.Color.textSecondary)
                    Text("Fall suchen...")
                        .font(DentIQ.Font.secondary)
                        .foregroundStyle(DentIQ.Color.textMuted)
                    Spacer()
                }
                .padding(.horizontal, DentIQ.Spacing.m)
                .frame(height: DentIQ.Spacing.minTapTarget)
                .background(Capsule().fill(DentIQ.Color.groupedSurface))
                .overlay(Capsule().strokeBorder(DentIQ.Color.hairline, lineWidth: DentIQ.Spacing.hairline))
                .contentShape(Capsule())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Fall suchen")

            Button(action: {}) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundStyle(DentIQ.Color.textPrimary)
                    .frame(width: DentIQ.Spacing.minTapTarget, height: DentIQ.Spacing.minTapTarget)
                    .background(Circle().fill(DentIQ.Color.groupedSurface))
                    .overlay(Circle().strokeBorder(DentIQ.Color.hairline, lineWidth: DentIQ.Spacing.hairline))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Filter")
        }
        .padding(.horizontal, DentIQ.Spacing.m)
    }
}
