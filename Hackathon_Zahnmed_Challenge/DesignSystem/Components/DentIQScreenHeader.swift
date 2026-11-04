import SwiftUI

/// Header-Muster für jeden Screen: Eyebrow oben links, darunter großer Manrope-Titel.
/// Rechts oben ist Platz für Logo oder eine Aktion (`trailing`).
struct DentIQScreenHeader<Trailing: View>: View {
    let eyebrow: String
    let title: String
    var subtitle: String?
    @ViewBuilder let trailing: () -> Trailing

    init(
        eyebrow: String,
        title: String,
        subtitle: String? = nil,
        @ViewBuilder trailing: @escaping () -> Trailing
    ) {
        self.eyebrow = eyebrow
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DentIQ.Spacing.s) {
            HStack(alignment: .top) {
                EyebrowLabel(eyebrow)
                Spacer(minLength: DentIQ.Spacing.m)
                trailing()
            }
            Text(title)
                .font(DentIQ.Font.screenTitle)
                .foregroundStyle(DentIQ.Color.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)
            if let subtitle {
                Text(subtitle)
                    .font(DentIQ.Font.secondary)
                    .foregroundStyle(DentIQ.Color.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension DentIQScreenHeader where Trailing == EmptyView {
    init(eyebrow: String, title: String, subtitle: String? = nil) {
        self.init(eyebrow: eyebrow, title: title, subtitle: subtitle) { EmptyView() }
    }
}
