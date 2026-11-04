import SwiftUI

// MARK: - HERO BANNER
/// Navy-Karte mit weichen Ecken: Dr. Lukas links, „Jetzt lernen & Punkte sammeln“ rechts.
struct HeroBannerView: View {
    private let height: CGFloat = 160

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.card, style: .continuous)
    }

    var body: some View {
        ZStack(alignment: .leading) {
            shape.fill(DentIQ.Color.surfaceInverse)
            Circle()
                .fill(DentIQ.Color.onInverse.opacity(0.06))
                .frame(width: 140, height: 140)
                .offset(x: 240, y: 20)
                .accessibilityHidden(true)
            HStack(alignment: .bottom, spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs) {
                Image("dr_lukas")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 140)
                    .clipped()
                    .accessibilityHidden(true)
                Text("Jetzt lernen &\nPunkte sammeln")
                    .font(DentIQ.Font.heading)
                    .foregroundStyle(DentIQ.Color.onInverse)
                    .lineSpacing(2)
                    .minimumScaleFactor(0.8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
        }
        .frame(height: height)
        .clipShape(shape)
        .dentIQElevation(in: shape)
        .padding(.horizontal, DentIQ.Spacing.m)
    }
}
