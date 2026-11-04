import SwiftUI

// MARK: - REUSABLE: Sortier-Zeile (Ziehen über die Liste + Pfeile)
struct SortItem: Identifiable {
    let id: UUID
    let label: String
    let correctRank: Int
}

struct SortRowView: View {
    let item: SortItem
    let rank: Int
    let submitted: Bool
    let isCorrect: Bool
    let onMoveUp: () -> Void
    let onMoveDown: () -> Void
    /// Pfeile hoch/runter zeigen (aus, wenn die Liste das Ziehen übernimmt).
    var showsArrows: Bool = true
    /// Eigene Kartenfläche zeichnen (aus, wenn die Liste sie als Zeilenhintergrund zeichnet).
    var drawsBackground: Bool = true

    private var state: OptionState {
        guard submitted else { return .idle }
        return isCorrect ? .correct : .wrong
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.tile, style: .continuous)
    }

    var body: some View {
        HStack(spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs) {
            if submitted {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.body)
                    .foregroundStyle(state.accent)
                    .accessibilityHidden(true)
            }
            Text("\(rank)")
                .font(DentIQ.Font.number)
                .monospacedDigit()
                .foregroundStyle(submitted ? DentIQ.Color.onInverse : DentIQ.Color.textSecondary)
                .frame(width: 26, height: 26)
                .background(Circle().fill(submitted ? state.accent : DentIQ.Color.groupedBackground))
            Text(item.label)
                .font(submitted ? DentIQ.Font.secondaryMedium : DentIQ.Font.secondary)
                .foregroundStyle(DentIQ.Color.textPrimary)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .frame(maxWidth: .infinity, alignment: .leading)
            if submitted && !isCorrect {
                Text("→ \(item.correctRank)")
                    .font(DentIQ.Font.number)
                    .foregroundStyle(DentIQ.Color.textPrimary)
                    .padding(.horizontal, DentIQ.Spacing.s - 2)
                    .padding(.vertical, 2)
                    .background(Capsule().fill(DentIQ.Color.groupedSurface))
                    .accessibilityLabel("Richtig wäre Platz \(item.correctRank)")
            }
            if !submitted && showsArrows {
                VStack(spacing: 0) {
                    Button(action: onMoveUp) {
                        Image(systemName: "chevron.up")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(DentIQ.Color.textPrimary)
                            .frame(width: 32, height: 24)
                    }
                    .accessibilityLabel("Nach oben")
                    Button(action: onMoveDown) {
                        Image(systemName: "chevron.down")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(DentIQ.Color.textPrimary)
                            .frame(width: 32, height: 24)
                    }
                    .accessibilityLabel("Nach unten")
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, drawsBackground ? DentIQ.Spacing.m - DentIQ.Spacing.xs : 0)
        .frame(maxHeight: .infinity)
        .background {
            if drawsBackground {
                shape.fill(state.background)
                    .overlay(shape.strokeBorder(state.border, lineWidth: state.isHighlighted ? 1.5 : DentIQ.Spacing.hairline))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: submitted)
    }
}
