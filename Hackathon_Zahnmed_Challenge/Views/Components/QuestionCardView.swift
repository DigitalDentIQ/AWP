import SwiftUI

// MARK: - REUSABLE: QuestionCardView
/// Fragekarte: Aufgabentyp als Eyebrow, Frage in Manrope.
struct QuestionCardView: View {
    let typeLabel: String
    let question: String
    let subtitle: String?

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.group, style: .continuous)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs) {
            VStack(alignment: .leading, spacing: DentIQ.Spacing.s) {
                EyebrowLabel(typeLabel)
                Text(question)
                    .font(DentIQ.Font.subheading)
                    .foregroundStyle(DentIQ.Color.textPrimary)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityAddTraits(.isHeader)
                if let subtitle {
                    Text(subtitle)
                        .font(DentIQ.Font.secondary)
                        .foregroundStyle(DentIQ.Color.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(DentIQ.Spacing.m)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(shape.fill(DentIQ.Color.groupedSurface))
            .dentIQElevation(in: shape)
        }
        .padding(.horizontal, DentIQ.Spacing.m)
    }
}
