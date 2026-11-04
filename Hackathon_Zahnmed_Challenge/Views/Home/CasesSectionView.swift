import SwiftUI

// MARK: - CASES SECTION
struct CasesSectionView: View {
    @ObservedObject var state: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs) {
            HStack {
                Text("Patientenfälle")
                    .font(DentIQ.Font.heading)
                    .foregroundStyle(DentIQ.Color.textPrimary)
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                Button(action: {}) {
                    HStack(spacing: DentIQ.Spacing.xs) {
                        Text("Alle sehen")
                        Image(systemName: "arrow.right").imageScale(.small)
                    }
                }
                .buttonStyle(.dentIQLink)
            }
            .padding(.horizontal, DentIQ.Spacing.m)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs) {
                    ForEach(state.cases) { patientCase in
                        NavigationLink(destination: CaseDetailView(patientCase: patientCase)) {
                            CaseCardView(patientCase: patientCase, isCompleted: state.isCompleted(patientCase))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, DentIQ.Spacing.m)
                // Platz für den weichen Schatten der Karten
                .padding(.vertical, DentIQ.Spacing.m)
            }
            .padding(.vertical, -DentIQ.Spacing.m + DentIQ.Spacing.xs)
        }
    }
}
