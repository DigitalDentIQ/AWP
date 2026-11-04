import SwiftUI

// MARK: - Avatar

/// Rundes Monogramm (erster Buchstabe des Nicknames), wie in Apples Kontakte-App.
struct RankingAvatar: View {
    enum Style {
        /// Auf hellem Grund (Liste).
        case standard
        /// Auf Navy-Fläche (Podest).
        case onInverse
    }

    let name: String
    var size: CGFloat = 40
    var style: Style = .standard
    /// Teal-Ring, z. B. für Platz 1.
    var showsRing: Bool = false

    private var initial: String {
        String(name.trimmingCharacters(in: .whitespaces).prefix(1)).uppercased()
    }

    var body: some View {
        Text(initial)
            .font(DentIQ.Font.monogram(size * 0.42))
            .foregroundStyle(style == .onInverse ? DentIQ.Color.onInverse : DentIQ.Color.textPrimary)
            .frame(width: size, height: size)
            .background(
                Circle().fill(style == .onInverse ? DentIQ.Color.onInverse.opacity(0.14) : DentIQ.Color.surfaceAccent)
            )
            .overlay(
                Circle()
                    .strokeBorder(DentIQ.Color.accent, lineWidth: showsRing ? 2.5 : 0)
                    .padding(-5)
            )
            .accessibilityHidden(true)
    }
}

// MARK: - Podest

/// Siegerpodest für die ersten drei Plätze auf einer Navy-Fläche: 2 · 1 · 3.
struct RankingPodium: View {
    struct Entry: Identifiable {
        let rank: Int
        let name: String
        let points: Int
        var isCurrentUser: Bool = false

        var id: Int { rank }
    }

    /// Die ersten drei Einträge, Reihenfolge egal. Fehlende Plätze bleiben leer.
    let entries: [Entry]

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.large, style: .continuous)
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: DentIQ.Spacing.s) {
            column(rank: 2)
            column(rank: 1)
            column(rank: 3)
        }
        .padding(.horizontal, DentIQ.Spacing.m)
        .padding(.top, DentIQ.Spacing.l + DentIQ.Spacing.xs)
        .background(shape.fill(DentIQ.Color.surfaceInverse))
        .clipShape(shape)
        .dentIQElevation(in: shape)
    }

    @ViewBuilder
    private func column(rank: Int) -> some View {
        if let entry = entries.first(where: { $0.rank == rank }) {
            VStack(spacing: DentIQ.Spacing.s) {
                RankingAvatar(
                    name: entry.name,
                    size: rank == 1 ? 64 : 52,
                    style: .onInverse,
                    showsRing: rank == 1
                )
                .padding(.bottom, DentIQ.Spacing.xs)

                VStack(spacing: 2) {
                    Text(entry.isCurrentUser ? "\(entry.name) (Du)" : entry.name)
                        .font(DentIQ.Font.bodyMedium)
                        .foregroundStyle(DentIQ.Color.onInverse)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Text("\(entry.points.formatted()) P.")
                        .font(DentIQ.Font.meta)
                        .monospacedDigit()
                        .foregroundStyle(DentIQ.Color.onInverseMuted)
                }

                block(rank: rank)
            }
            .frame(maxWidth: .infinity)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Platz \(rank), \(entry.name), \(entry.points) Punkte")
        } else {
            Color.clear.frame(maxWidth: .infinity, maxHeight: 1)
        }
    }

    private func block(rank: Int) -> some View {
        let height: CGFloat = switch rank {
        case 1: 116
        case 2: 88
        default: 72
        }
        let blockShape = UnevenRoundedRectangle(
            topLeadingRadius: DentIQ.Radius.card - DentIQ.Spacing.s,
            topTrailingRadius: DentIQ.Radius.card - DentIQ.Spacing.s,
            style: .continuous
        )
        return ZStack(alignment: .top) {
            blockShape.fill(DentIQ.Color.onInverse.opacity(rank == 1 ? 0.16 : 0.08))
            Text("\(rank)")
                .font(DentIQ.Font.kpi)
                .foregroundStyle(rank == 1 ? DentIQ.Color.onInverse : DentIQ.Color.onInverseMuted)
                .padding(.top, DentIQ.Spacing.s)
        }
        .frame(height: height)
        .overlay(alignment: .top) {
            if rank == 1 {
                AccentLine().padding(.top, -1)
            }
        }
    }
}

// MARK: - Zeile

/// Ranglisten-Zeile: Platz, Monogramm, Name, Punkte. Die eigene Zeile liegt auf Soft Mint.
struct RankingRow: View {
    let rank: Int
    let name: String
    let points: Int
    var detail: String?
    var isCurrentUser: Bool = false

    @ScaledMetric(relativeTo: .body) private var rankWidth: CGFloat = 32

    var body: some View {
        HStack(spacing: DentIQ.Spacing.m) {
            Text("\(rank)")
                .font(DentIQ.Font.subheading)
                .monospacedDigit()
                .foregroundStyle(isCurrentUser ? DentIQ.Color.accent : DentIQ.Color.textSecondary)
                .frame(minWidth: rankWidth, alignment: .leading)

            RankingAvatar(name: name)

            VStack(alignment: .leading, spacing: 2) {
                Text(isCurrentUser ? "\(name) (Du)" : name)
                    .font(DentIQ.Font.bodyMedium)
                    .foregroundStyle(DentIQ.Color.textPrimary)
                    .lineLimit(1)
                if let detail {
                    Text(detail)
                        .font(DentIQ.Font.meta)
                        .foregroundStyle(DentIQ.Color.textSecondary)
                }
            }

            Spacer(minLength: DentIQ.Spacing.s)

            Text("\(points.formatted()) P.")
                .font(DentIQ.Font.subheading)
                .monospacedDigit()
                .foregroundStyle(DentIQ.Color.textPrimary)
        }
        .padding(.horizontal, DentIQ.Spacing.m)
        .padding(.vertical, DentIQ.Spacing.m - DentIQ.Spacing.xs)
        .background {
            if isCurrentUser {
                RoundedRectangle(cornerRadius: DentIQ.Radius.group, style: .continuous)
                    .fill(DentIQ.Color.surfaceAccent)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Platz \(rank), \(isCurrentUser ? "Du, " : "")\(name), \(points) Punkte")
    }
}
