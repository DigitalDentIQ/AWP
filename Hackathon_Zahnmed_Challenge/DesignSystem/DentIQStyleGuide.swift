import SwiftUI

/// Übersicht aller Design-Tokens. Nur für die Xcode-Vorschau gedacht, nicht Teil der App-Navigation.
struct DentIQStyleGuide: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DentIQ.Spacing.xl) {
                header
                colors
                typography
            }
            .padding(.horizontal, DentIQ.Spacing.margin)
            .padding(.vertical, DentIQ.Spacing.l)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(DentIQ.Color.background)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: DentIQ.Spacing.s) {
            Text("DESIGNSYSTEM / ÜBERSICHT")
                .font(DentIQ.Font.eyebrow)
                .tracking(DentIQ.Font.eyebrowTracking)
                .foregroundStyle(DentIQ.Color.accent)
            Text("Klar im Denken. Präzise im Handeln.")
                .font(DentIQ.Font.display)
                .foregroundStyle(DentIQ.Color.textPrimary)
            Rectangle()
                .fill(DentIQ.Color.accent)
                .frame(width: DentIQ.Spacing.accentLineWidth, height: DentIQ.Spacing.accentLineHeight)
        }
    }

    private var colors: some View {
        VStack(alignment: .leading, spacing: DentIQ.Spacing.s) {
            Text("Farben")
                .font(DentIQ.Font.heading)
                .foregroundStyle(DentIQ.Color.textPrimary)
            ForEach(Self.swatches, id: \.name) { swatch in
                HStack(spacing: DentIQ.Spacing.m) {
                    Rectangle()
                        .fill(swatch.color)
                        .frame(width: DentIQ.Spacing.minTapTarget, height: DentIQ.Spacing.minTapTarget)
                        .overlay(Rectangle().stroke(DentIQ.Color.hairline, lineWidth: DentIQ.Spacing.hairline))
                    Text(swatch.name)
                        .font(DentIQ.Font.secondary)
                        .foregroundStyle(DentIQ.Color.textSecondary)
                }
            }
        }
    }

    private var typography: some View {
        VStack(alignment: .leading, spacing: DentIQ.Spacing.m) {
            Text("Schrift")
                .font(DentIQ.Font.heading)
                .foregroundStyle(DentIQ.Color.textPrimary)
            Text("Screen-Titel").font(DentIQ.Font.screenTitle).foregroundStyle(DentIQ.Color.textPrimary)
            Text("Zwischenüberschrift").font(DentIQ.Font.heading).foregroundStyle(DentIQ.Color.textPrimary)
            Text("Kartentitel").font(DentIQ.Font.subheading).foregroundStyle(DentIQ.Color.textPrimary)
            Text("1.240").font(DentIQ.Font.kpi).foregroundStyle(DentIQ.Color.accent)
            Text("Fließtext in Plus Jakarta Sans. Kurze, klare Sätze.")
                .font(DentIQ.Font.body).foregroundStyle(DentIQ.Color.textPrimary)
            Text("Betonter Text").font(DentIQ.Font.bodyMedium).foregroundStyle(DentIQ.Color.textPrimary)
            Text("Sekundärtext für Beschreibungen.").font(DentIQ.Font.secondary).foregroundStyle(DentIQ.Color.textSecondary)
            Text("01").font(DentIQ.Font.number).foregroundStyle(DentIQ.Color.accent)
            Text("Footer · Meta · Hilfstext").font(DentIQ.Font.meta).foregroundStyle(DentIQ.Color.textMuted)
            Text("Falsche Antwort.").font(DentIQ.Font.body).foregroundStyle(DentIQ.Color.error)
        }
    }

    private struct Swatch {
        let name: String
        let color: Color
    }

    private static let swatches: [Swatch] = [
        Swatch(name: "background", color: DentIQ.Color.background),
        Swatch(name: "surface", color: DentIQ.Color.surface),
        Swatch(name: "surfaceAccent", color: DentIQ.Color.surfaceAccent),
        Swatch(name: "surfaceInverse", color: DentIQ.Color.surfaceInverse),
        Swatch(name: "textPrimary", color: DentIQ.Color.textPrimary),
        Swatch(name: "textSecondary", color: DentIQ.Color.textSecondary),
        Swatch(name: "textMuted", color: DentIQ.Color.textMuted),
        Swatch(name: "accent", color: DentIQ.Color.accent),
        Swatch(name: "error (nicht CI)", color: DentIQ.Color.error),
        Swatch(name: "hairline", color: DentIQ.Color.hairline),
        Swatch(name: "buttonPrimary", color: DentIQ.Color.buttonPrimary),
    ]
}

#Preview("Hell") {
    DentIQStyleGuide()
        .onAppear { DentIQ.Font.verifyRegistration() }
}

#Preview("Dunkel") {
    DentIQStyleGuide()
        .preferredColorScheme(.dark)
}
