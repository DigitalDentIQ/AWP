import SwiftUI

// ─────────────────────────────────────────────
// MARK: - ÜBERSICHTSSEITE
// ─────────────────────────────────────────────

struct ModelOverviewView: View {

    let modelle: [ZahnModell] = [
        ZahnModell(id: 1,
                   name: "Ausgangsbefund",
                   beschreibung: "Zustand nach dem Unfall",
                   dateiname: "Hackathon_Fall1",
                   art: .befund,
                   icon: "magnifyingglass.circle.fill"),
        ZahnModell(id: 2,
                   name: "Fehlerhafte Versorgung",
                   beschreibung: "Fehler bei Reposition und Schienung erkennen",
                   dateiname: "Hackathon_Fall1_Fehlerhaft",
                   art: .fehlerhaft,
                   icon: "xmark.circle.fill"),
        ZahnModell(id: 3,
                   name: "Korrekte Versorgung",
                   beschreibung: "Reposition und Titan-Trauma-Splint",
                   dateiname: "Hackathon_Fall1_Repariert",
                   art: .korrekt,
                   icon: "checkmark.circle.fill")
    ]

    @Environment(\.dismiss) var dismiss

    private var tileShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.tile, style: .continuous)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DentIQ.Spacing.l) {

                // Header
                VStack(alignment: .leading, spacing: DentIQ.Spacing.s - 2) {
                    Text("3D Modelle")
                        .font(DentIQ.Font.screenTitle)
                        .foregroundStyle(DentIQ.Color.textPrimary)
                        .accessibilityAddTraits(.isHeader)
                    Text("Fall 1 · Volksfest-Unfall (Frontzahntrauma)")
                        .font(DentIQ.Font.secondary)
                        .foregroundStyle(DentIQ.Color.textSecondary)
                }
                .padding(.horizontal, DentIQ.Spacing.m)
                .padding(.top, DentIQ.Spacing.s)

                // Info-Banner
                HStack(spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs) {
                    Image(systemName: "rotate.3d")
                        .font(.title3)
                        .foregroundStyle(DentIQ.Color.accent)
                        .accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Interaktive 3D-Ansicht")
                            .font(DentIQ.Font.secondaryMedium)
                            .foregroundStyle(DentIQ.Color.textPrimary)
                        Text("Tippe auf ein Modell · Drehen mit dem Finger")
                            .font(DentIQ.Font.meta)
                            .foregroundStyle(DentIQ.Color.textSecondary)
                    }
                    Spacer()
                }
                .padding(DentIQ.Spacing.m - 2)
                .background(tileShape.fill(DentIQ.Color.surfaceAccent))
                .padding(.horizontal, DentIQ.Spacing.m)

                // Modell-Karten
                VStack(spacing: DentIQ.Spacing.m) {
                    ForEach(modelle) { modell in
                        NavigationLink(destination: ModelDetailView(modell: modell)) {
                            ModellKarteView(modell: modell)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, DentIQ.Spacing.m)

                // Lerntipp
                VStack(alignment: .leading, spacing: DentIQ.Spacing.s) {
                    Label {
                        Text("Lerntipp").foregroundStyle(DentIQ.Color.textPrimary)
                    } icon: {
                        Image(systemName: "lightbulb").foregroundStyle(DentIQ.Color.accent)
                    }
                    .font(DentIQ.Font.secondaryMedium)
                    Text("Vergleiche die drei Modelle miteinander. Erkennst du den Unterschied zwischen der fehlerhaften und der korrekten Versorgung?")
                        .font(DentIQ.Font.secondary)
                        .foregroundStyle(DentIQ.Color.textPrimary)
                        .lineSpacing(4)
                }
                .padding(DentIQ.Spacing.m - 2)
                .padding(.leading, DentIQ.Spacing.xs)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(tileShape.fill(DentIQ.Color.surfaceAccent))
                .overlay(alignment: .leading) {
                    Rectangle().fill(DentIQ.Color.accent).frame(width: 3)
                }
                .clipShape(tileShape)
                .padding(.horizontal, DentIQ.Spacing.m)

                Spacer(minLength: DentIQ.Spacing.xl)
            }
            .padding(.top, DentIQ.Spacing.s)
        }
        .background(DentIQ.Color.groupedBackground)
        .navigationTitle("3D Modelle")
        .navigationBarTitleDisplayMode(.inline)
    }
}
