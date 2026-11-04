import SwiftUI

// MARK: - CASE CARD
struct CaseCardView: View {
    let patientCase: PatientCase
    let isCompleted: Bool

    private var progress: Double { isCompleted ? 1 : 0 }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.group, style: .continuous)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                // Ruhige Mint-Fläche statt Farbverlauf (CI)
                DentIQ.Color.surfaceAccent
                Image(systemName: patientCase.sfSymbol)
                    .font(.system(size: 38, weight: .light))
                    .foregroundStyle(DentIQ.Color.accent)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .accessibilityHidden(true)
                if isCompleted {
                    cornerLabel("Abgeschlossen", systemImage: "checkmark.seal.fill")
                } else if let badge = patientCase.badge {
                    cornerLabel(badge.text, systemImage: nil)
                }
            }
            .frame(height: 96)

            VStack(alignment: .leading, spacing: 5) {
                Text(patientCase.category.uppercased())
                    .font(DentIQ.Font.eyebrow)
                    .tracking(DentIQ.Font.eyebrowTracking)
                    .foregroundStyle(DentIQ.Color.textSecondary)
                Text(patientCase.title)
                    .font(DentIQ.Font.subheading)
                    .foregroundStyle(DentIQ.Color.textPrimary)
                    // Immer Platz für zwei Zeilen, damit alle Karten gleich hoch sind
                    .lineLimit(2, reservesSpace: true)
                HStack(spacing: 3) {
                    ForEach(1...3, id: \.self) { i in
                        Image(systemName: i <= patientCase.difficulty ? "star.fill" : "star")
                            .imageScale(.small)
                            .foregroundStyle(i <= patientCase.difficulty ? DentIQ.Color.accent : DentIQ.Color.hairline)
                    }
                    Text(patientCase.difficultyLabel)
                        .font(DentIQ.Font.meta)
                        .foregroundStyle(DentIQ.Color.textSecondary)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Schwierigkeit: \(patientCase.difficultyLabel)")
                DentIQProgressBar(value: progress)
                    .padding(.top, DentIQ.Spacing.xs)
                HStack {
                    Spacer()
                    Text("\(Int(progress * Double(patientCase.totalSteps))) / \(patientCase.totalSteps) Schritte")
                        .font(DentIQ.Font.meta)
                        .foregroundStyle(DentIQ.Color.textSecondary)
                }
            }
            .padding(DentIQ.Spacing.m - DentIQ.Spacing.xs)
        }
        .frame(width: 200)
        .background(DentIQ.Color.groupedSurface)
        .clipShape(shape)
        .dentIQElevation(in: shape)
    }

    /// Kleines Etikett oben rechts auf der Mint-Fläche.
    private func cornerLabel(_ text: String, systemImage: String?) -> some View {
        HStack(spacing: DentIQ.Spacing.xs) {
            if let systemImage {
                Image(systemName: systemImage)
            }
            Text(text)
        }
        .font(DentIQ.Font.meta)
        .foregroundStyle(DentIQ.Color.accent)
        .padding(.horizontal, DentIQ.Spacing.s)
        .padding(.vertical, DentIQ.Spacing.xs)
        .background(Capsule().fill(DentIQ.Color.groupedSurface))
        .padding(DentIQ.Spacing.s)
    }
}
