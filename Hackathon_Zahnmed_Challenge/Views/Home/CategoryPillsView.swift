import SwiftUI

// MARK: - CATEGORY PILLS
struct CategoryPillsView: View {
    @ObservedObject var state: AppState

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DentIQ.Spacing.s) {
                ForEach(state.categories, id: \.self) { cat in
                    let isSelected = state.selectedCategory == cat
                    Button(action: { state.selectedCategory = cat }) {
                        Text(cat)
                            .font(DentIQ.Font.secondary)
                            .foregroundStyle(isSelected ? DentIQ.Color.onButtonPrimary : DentIQ.Color.textPrimary)
                            .padding(.horizontal, DentIQ.Spacing.m)
                            .padding(.vertical, 9)
                            .background(Capsule().fill(isSelected ? DentIQ.Color.buttonPrimary : DentIQ.Color.groupedSurface))
                            .overlay(
                                Capsule().strokeBorder(DentIQ.Color.hairline, lineWidth: isSelected ? 0 : DentIQ.Spacing.hairline)
                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            }
            .padding(.horizontal, DentIQ.Spacing.m)
        }
        .sensoryFeedback(.selection, trigger: state.selectedCategory)
    }
}
