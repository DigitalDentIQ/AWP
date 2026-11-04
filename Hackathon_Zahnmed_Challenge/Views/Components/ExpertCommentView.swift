import SwiftUI

// MARK: - REUSABLE: Expert Comment Card
/// Expertenkommentar nach dem Beantworten: Mint-Fläche mit Teal-Kante links.
struct ExpertCommentView: View {
    let score: Int
    let text: String

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.tile, style: .continuous)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DentIQ.Spacing.s + 2) {
            HStack {
                Label {
                    Text("Expertenkommentar")
                        .foregroundStyle(DentIQ.Color.textPrimary)
                } icon: {
                    Image(systemName: "stethoscope")
                        .foregroundStyle(DentIQ.Color.accent)
                }
                .font(DentIQ.Font.secondaryMedium)
                Spacer()
                if score > 0 {
                    Text("+\(score) Punkte")
                        .font(DentIQ.Font.number)
                        .foregroundStyle(DentIQ.Color.accent)
                }
            }
            Text(text)
                .font(DentIQ.Font.secondary)
                .foregroundStyle(DentIQ.Color.textPrimary)
                .lineSpacing(4)
        }
        .padding(DentIQ.Spacing.m - 2)
        .padding(.leading, DentIQ.Spacing.xs)
        .background(shape.fill(DentIQ.Color.surfaceAccent))
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(DentIQ.Color.accent)
                .frame(width: 3)
        }
        .clipShape(shape)
    }
}
