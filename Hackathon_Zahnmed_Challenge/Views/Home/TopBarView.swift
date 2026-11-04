import SwiftUI

// MARK: - TOP BAR
/// Kopf der Startseite: DentIQ-Schriftzug oben links, Profil oben rechts, darunter die Begrüßung.
struct TopBarView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var backend: BackendService

    var body: some View {
        VStack(alignment: .leading, spacing: DentIQ.Spacing.m) {
            HStack {
                // Platzhalter, bis das Vektorlogo da ist (Schritt 13)
                Text("\(Text("Dent").foregroundStyle(DentIQ.Color.textPrimary))\(Text("IQ").foregroundStyle(DentIQ.Color.accent))")
                    .font(DentIQ.Font.heading)
                    .accessibilityLabel("DentIQ")
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                NavigationLink {
                    ProfileView()
                } label: {
                    Image(systemName: "person.crop.circle")
                        .font(.title2)
                        .foregroundStyle(DentIQ.Color.textPrimary)
                        .frame(width: DentIQ.Spacing.minTapTarget, height: DentIQ.Spacing.minTapTarget)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Profil")
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Willkommen zurück")
                    .font(DentIQ.Font.secondary)
                    .foregroundStyle(DentIQ.Color.textSecondary)
                Text(backend.profile?.nickname ?? "Nickname festlegen")
                    .font(DentIQ.Font.heading)
                    .foregroundStyle(DentIQ.Color.textPrimary)
            }
            .accessibilityElement(children: .combine)
        }
        .padding(.horizontal, DentIQ.Spacing.m)
        .padding(.top, DentIQ.Spacing.xs)
    }
}
