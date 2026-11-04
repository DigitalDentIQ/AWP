import SwiftUI

// MARK: - APP-TOUR (Dr. Lukas erklärt die App)
struct AppTourView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var page = 0

    private struct TourPage {
        let icon: String
        let title: String
        let text: String
    }

    private let pages: [TourPage] = [
        TourPage(icon: "person.crop.circle.badge.checkmark", title: "Willkommen!",
                 text: "Ich bin Dr. Lukas und begleite dich durch realistische Patientenfälle – vom ersten Gespräch bis zur Therapie."),
        TourPage(icon: "cross.case.fill", title: "Patientenfälle",
                 text: "Jeder Fall erzählt die Geschichte einer Patientin oder eines Patienten. Du entscheidest Schritt für Schritt: Untersuchung, Diagnose, Therapie."),
        TourPage(icon: "checklist", title: "Aufgaben & Punkte",
                 text: "Multiple Choice, Röntgenbilder, Sortieren, Zuordnen und Freitext. Nach jeder Antwort bekommst du einen Expertenkommentar und Punkte."),
        TourPage(icon: "bubble.left.and.text.bubble.right.fill", title: "Ich helfe dir",
                 text: "In jedem Schritt kannst du mich fragen. Ich gebe Denkanstöße statt Lösungen. Nach dem Antworten erkläre ich dir, warum etwas falsch war."),
        TourPage(icon: "trophy.fill", title: "Ranking & Profil",
                 text: "Lege oben auf der Startseite einen Nickname fest und vergleiche dich im Ranking. Abgeschlossene Fälle kannst du jederzeit wiederholen."),
        TourPage(icon: "cube.transparent", title: "3D-Modelle",
                 text: "Sieh dir die Gebissmodelle zu den Fällen in 3D an – auf dem iPhone sogar in AR. Viel Erfolg!")
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button("Überspringen", action: finish)
                    .font(DentIQ.Font.secondaryMedium)
                    .foregroundStyle(DentIQ.Color.textSecondary)
                    .frame(minHeight: DentIQ.Spacing.minTapTarget)
            }
            .padding(.horizontal, DentIQ.Spacing.m)
            .padding(.top, DentIQ.Spacing.s)

            TabView(selection: $page) {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, item in
                    VStack(spacing: DentIQ.Spacing.m + DentIQ.Spacing.xs) {
                        ZStack(alignment: .bottomTrailing) {
                            Image("dr_lukas").resizable().scaledToFill()
                                .frame(width: 110, height: 110)
                                .background(DentIQ.Color.surfaceAccent)
                                .clipShape(Circle())
                                .accessibilityHidden(true)
                            Image(systemName: item.icon)
                                .font(.body.weight(.semibold))
                                .foregroundStyle(DentIQ.Color.onInverse)
                                .frame(width: 40, height: 40)
                                .background(Circle().fill(DentIQ.Color.accent))
                                .accessibilityHidden(true)
                        }
                        Text(item.title)
                            .font(DentIQ.Font.heading)
                            .foregroundStyle(DentIQ.Color.textPrimary)
                            .accessibilityAddTraits(.isHeader)
                        Text(item.text)
                            .font(DentIQ.Font.secondary)
                            .foregroundStyle(DentIQ.Color.textSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.horizontal, DentIQ.Spacing.xl - DentIQ.Spacing.s)
                        Spacer()
                    }
                    .padding(.top, DentIQ.Spacing.l)
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            Button(action: next) {
                HStack(spacing: DentIQ.Spacing.s) {
                    Text(page == pages.count - 1 ? "Los geht's" : "Weiter")
                    Image(systemName: page == pages.count - 1 ? "checkmark" : "arrow.right")
                }
            }
            .buttonStyle(.dentIQPrimary)
            .padding(DentIQ.Spacing.m)
        }
        .background(DentIQ.Color.groupedBackground.ignoresSafeArea())
    }

    private func next() {
        if page < pages.count - 1 {
            withAnimation { page += 1 }
        } else {
            finish()
        }
    }

    private func finish() {
        appState.markTourSeen()
        dismiss()
    }
}
