import SwiftUI

/// Alle Basisbausteine auf einer Seite. Nur für die Xcode-Vorschau gedacht.
struct DentIQComponentsGallery: View {
    @State private var searchText = ""
    @FocusState private var searchFocused: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DentIQ.Spacing.xl) {
                DentIQScreenHeader(
                    eyebrow: "Fälle / Übersicht",
                    title: "Klar im Denken.",
                    subtitle: "Drei Patientenfälle warten auf dich."
                ) {
                    Image(systemName: "bell")
                        .foregroundStyle(DentIQ.Color.textPrimary)
                        .frame(width: DentIQ.Spacing.minTapTarget, height: DentIQ.Spacing.minTapTarget)
                }

                TextField("Fall suchen", text: $searchText)
                    .focused($searchFocused)
                    .dentIQInputFrame(isFocused: searchFocused)

                DentIQCard(style: .accent, showsAccentLine: true) {
                    Text("Kernaussage")
                        .font(DentIQ.Font.heading)
                        .foregroundStyle(DentIQ.Color.textPrimary)
                    Text("Ruhige Fläche in Soft Mint mit kurzer Teal-Linie oben.")
                        .font(DentIQ.Font.body)
                        .foregroundStyle(DentIQ.Color.textSecondary)
                }

                VStack(alignment: .leading, spacing: DentIQ.Spacing.m) {
                    SectionHeading(number: "01", title: "Notfallbehandlung")
                    HairlineDivider()
                    SectionHeading(number: "02", title: "Endodontie")
                    HairlineDivider()
                    SectionHeading(number: "03", title: "Parodontologie")
                }

                HStack(alignment: .top, spacing: DentIQ.Spacing.l) {
                    KPIView(value: "1.240", label: "Punkte", caption: "Stand heute")
                    KPIView(value: "#3", label: "Rang", caption: "von 48")
                }

                VStack(alignment: .leading, spacing: DentIQ.Spacing.m) {
                    ProgressSteps(current: 3, total: 8)
                    DentIQProgressBar(value: 0.4)
                }

                VStack(alignment: .leading, spacing: DentIQ.Spacing.m) {
                    EyebrowLabel("Ranking / Diese Woche")
                    RankingPodium(entries: [
                        .init(rank: 1, name: "Lena", points: 1480),
                        .init(rank: 2, name: "Jonas", points: 1320),
                        .init(rank: 3, name: "Maxi", points: 1240, isCurrentUser: true),
                    ])
                    VStack(spacing: 0) {
                        ForEach(Self.ranking, id: \.rank) { entry in
                            RankingRow(
                                rank: entry.rank,
                                name: entry.name,
                                points: entry.points,
                                detail: "\(entry.cases) Fälle abgeschlossen",
                                isCurrentUser: entry.name == "Sara"
                            )
                        }
                    }
                }

                VStack(spacing: DentIQ.Spacing.m) {
                    Button("Weiter") {}.buttonStyle(.dentIQPrimary)
                    Button("Weiter") {}.buttonStyle(.dentIQPrimary).disabled(true)
                    Button("Fall neu starten") {}.buttonStyle(.dentIQSecondary)
                    Button("Alle ansehen") {}.buttonStyle(.dentIQLink)
                }

                DentIQChapterPanel(
                    numeral: "01",
                    eyebrow: "Fall / Abgeschlossen",
                    title: "Präzise im Handeln.",
                    text: "Du hast 8 von 8 Schritten gelöst."
                )
            }
            .padding(.horizontal, DentIQ.Spacing.margin)
            .padding(.vertical, DentIQ.Spacing.l)
        }
        .background(DentIQ.Color.background)
    }

    private static let ranking: [(rank: Int, name: String, points: Int, cases: Int)] = [
        (4, "Forester", 1180, 3), (5, "Faizan", 1120, 3), (6, "Sara", 990, 2), (7, "Tom", 860, 2),
    ]
}

#Preview("Hell") {
    DentIQComponentsGallery()
}

#Preview("Dunkel") {
    DentIQComponentsGallery()
        .preferredColorScheme(.dark)
}
