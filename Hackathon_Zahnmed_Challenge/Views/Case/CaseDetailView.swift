import SwiftUI

// MARK: - CASE DETAIL
/// Bisheriges Layout, im DentIQ-Design: Bild, Patient, Stichworte, Fallverlauf, Start.
struct CaseDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navState: NavState
    @EnvironmentObject private var appState: AppState
    @State private var confirmReset = false
    let patientCase: PatientCase

    private var isCompleted: Bool { appState.isCompleted(patientCase) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DentIQ.Spacing.m + DentIQ.Spacing.xs) {
                header
                patientCard
                timeline
                if isCompleted {
                    completedBox
                }
                NavigationLink(destination: CaseRunnerView(patientCase: patientCase)) {
                    Text(isCompleted ? "Fall erneut starten" : "Fall starten")
                }
                .buttonStyle(.dentIQPrimary)
                .padding(.horizontal, DentIQ.Spacing.m)
                .padding(.bottom, isCompleted ? 0 : DentIQ.Spacing.l)

                if isCompleted {
                    Button(action: { confirmReset = true }) {
                        Label("Fortschritt zurücksetzen", systemImage: "arrow.counterclockwise")
                            .font(DentIQ.Font.secondary)
                            .foregroundStyle(DentIQ.Color.textSecondary)
                            .frame(maxWidth: .infinity, minHeight: DentIQ.Spacing.minTapTarget)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, DentIQ.Spacing.l)
                }
            }
            .padding(.top, DentIQ.Spacing.m)
        }
        .confirmationDialog("Fortschritt für diesen Fall zurücksetzen?",
                            isPresented: $confirmReset, titleVisibility: .visible) {
            Button("Zurücksetzen", role: .destructive) { appState.resetProgress(for: patientCase) }
        } message: {
            Text("Der Fall wird wieder als offen angezeigt. Dein Ergebnis im Ranking bleibt erhalten.")
        }
        .navigationTitle(patientCase.title)
        .navigationBarTitleDisplayMode(.inline)
        .background(DentIQ.Color.groupedBackground)
    }

    // MARK: Bild mit Etiketten

    private var headerShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.card, style: .continuous)
    }

    private var header: some View {
        ZStack(alignment: .bottomLeading) {
            if let image = patientCase.patient.image {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel("Foto: \(patientCase.patient.name)")
            } else {
                // Ruhige Mint-Fläche statt Farbverlauf (CI)
                DentIQ.Color.surfaceAccent
                    .frame(height: 200)
                Image(systemName: patientCase.sfSymbol)
                    .font(.system(size: 72, weight: .light))
                    .foregroundStyle(DentIQ.Color.accent)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 30)
                    .accessibilityHidden(true)
            }
            HStack {
                Label(patientCase.appearance.headerLabel, systemImage: patientCase.appearance.headerIcon)
                    .modifier(HeaderChip())
                Spacer()
                HStack(spacing: 3) {
                    ForEach(1...3, id: \.self) { i in
                        Image(systemName: i <= patientCase.difficulty ? "star.fill" : "star")
                            .imageScale(.small)
                            .foregroundStyle(i <= patientCase.difficulty ? DentIQ.Color.accent : DentIQ.Color.onInverseMuted)
                    }
                    Text(patientCase.difficultyLabel)
                }
                .modifier(HeaderChip())
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Schwierigkeit: \(patientCase.difficultyLabel)")
            }
            .padding(DentIQ.Spacing.m - DentIQ.Spacing.xs)
        }
        .frame(height: 200)
        .clipShape(headerShape)
        .dentIQElevation(in: headerShape)
        .padding(.horizontal, DentIQ.Spacing.m)
    }

    // MARK: Patient

    private var patientCard: some View {
        let shape = RoundedRectangle(cornerRadius: DentIQ.Radius.group, style: .continuous)
        return VStack(alignment: .leading, spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs) {
            HStack(spacing: DentIQ.Spacing.s + DentIQ.Spacing.xs) {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                    .foregroundStyle(DentIQ.Color.accent)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    Text(patientCase.patient.name)
                        .font(DentIQ.Font.subheading)
                        .foregroundStyle(DentIQ.Color.textPrimary)
                    Text(patientCase.patient.details)
                        .font(DentIQ.Font.meta)
                        .foregroundStyle(DentIQ.Color.textSecondary)
                }
            }
            HairlineDivider()
            if let intro = patientCase.patient.intro {
                Text(intro)
                    .font(DentIQ.Font.secondary)
                    .foregroundStyle(DentIQ.Color.textPrimary)
                    .lineSpacing(4)
            }
            if let quote = patientCase.patient.quote {
                // Zitat mit Teal-Linie statt Kursivschrift (Plus Jakarta Sans ist hier ohne Kursivschnitt eingebunden)
                HStack(alignment: .top, spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs) {
                    Capsule()
                        .fill(DentIQ.Color.accent)
                        .frame(width: DentIQ.Spacing.accentLineHeight)
                    Text("„\(quote)“")
                        .font(DentIQ.Font.secondary)
                        .foregroundStyle(DentIQ.Color.textSecondary)
                        .lineSpacing(4)
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(DentIQ.Spacing.m)
        .background(shape.fill(DentIQ.Color.groupedSurface))
        .dentIQElevation(in: shape)
        .padding(.horizontal, DentIQ.Spacing.m)
    }

    // MARK: Fallverlauf

    /// Zwei Spalten, damit alle Schritte ohne Scrollen sichtbar sind.
    private let timelineColumns = [
        GridItem(.flexible(), spacing: DentIQ.Spacing.m, alignment: .leading),
        GridItem(.flexible(), spacing: DentIQ.Spacing.m, alignment: .leading),
    ]

    private var timeline: some View {
        let shape = RoundedRectangle(cornerRadius: DentIQ.Radius.group, style: .continuous)
        return VStack(alignment: .leading, spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs) {
            Text("Fallverlauf")
                .font(DentIQ.Font.subheading)
                .foregroundStyle(DentIQ.Color.textPrimary)
                .accessibilityAddTraits(.isHeader)
            LazyVGrid(columns: timelineColumns, alignment: .leading, spacing: DentIQ.Spacing.s + DentIQ.Spacing.xs) {
                ForEach(Array(patientCase.steps.enumerated()), id: \.element.id) { i, step in
                    TimelineStep(number: i + 1, label: step.label, isFirst: i == 0)
                }
            }
        }
        .padding(DentIQ.Spacing.m)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(shape.fill(DentIQ.Color.groupedSurface))
        .dentIQElevation(in: shape)
        .padding(.horizontal, DentIQ.Spacing.m)
    }

    // MARK: Abgeschlossen

    private var completedBox: some View {
        let shape = RoundedRectangle(cornerRadius: DentIQ.Radius.tile, style: .continuous)
        return HStack {
            Label {
                Text("Abgeschlossen").foregroundStyle(DentIQ.Color.textPrimary)
            } icon: {
                Image(systemName: "checkmark.seal.fill").foregroundStyle(DentIQ.Color.accent)
            }
            .font(DentIQ.Font.bodyMedium)
            Spacer()
            Text("Bestes Ergebnis: \(appState.bestScore(for: patientCase) ?? 0) / \(patientCase.maxScore)")
                .font(DentIQ.Font.secondary)
                .foregroundStyle(DentIQ.Color.textSecondary)
        }
        .padding(DentIQ.Spacing.m - DentIQ.Spacing.xs)
        .background(shape.fill(DentIQ.Color.surfaceAccent))
        .padding(.horizontal, DentIQ.Spacing.m)
    }
}

// MARK: - Schritt im Fallverlauf
/// Nummer im Kreis und Name daneben. Der erste Schritt ist in Teal hervorgehoben.
private struct TimelineStep: View {
    let number: Int
    let label: String
    let isFirst: Bool

    @ScaledMetric(relativeTo: .caption) private var size: CGFloat = 24

    var body: some View {
        HStack(spacing: DentIQ.Spacing.s) {
            Text("\(number)")
                .font(DentIQ.Font.meta)
                .monospacedDigit()
                .foregroundStyle(isFirst ? DentIQ.Color.onInverse : DentIQ.Color.textSecondary)
                .frame(width: size, height: size)
                .background(Circle().fill(isFirst ? DentIQ.Color.accent : DentIQ.Color.groupedBackground))
                .overlay(
                    Circle().strokeBorder(isFirst ? Color.clear : DentIQ.Color.hairline,
                                          lineWidth: DentIQ.Spacing.hairline)
                )
            Text(label)
                .font(DentIQ.Font.secondary)
                .foregroundStyle(isFirst ? DentIQ.Color.textPrimary : DentIQ.Color.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Schritt \(number): \(label)")
    }
}

// MARK: - Etikett auf dem Bild
/// Navy-Kapsel mit weißer Schrift, gut lesbar auf Foto und Fläche.
private struct HeaderChip: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(DentIQ.Font.meta)
            .foregroundStyle(DentIQ.Color.onInverse)
            .padding(.horizontal, DentIQ.Spacing.s + 2)
            .padding(.vertical, DentIQ.Spacing.xs + 1)
            .background(Capsule().fill(DentIQ.Color.surfaceInverse.opacity(0.85)))
    }
}
