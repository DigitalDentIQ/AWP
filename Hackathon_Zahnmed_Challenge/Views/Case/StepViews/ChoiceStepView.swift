import SwiftUI

// MARK: - STEP: SINGLE / MULTIPLE CHOICE / BILDAUSWAHL
struct ChoiceStepView: View {
    let step: CaseStep
    let task: ChoiceTask
    let allowsMultiple: Bool
    @ObservedObject var session: CaseSession
    @State private var selected: Set<Int> = []
    @State private var submitted = false
    @State private var score = 0
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    /// Spalten für Text-Antworten: kurze Antworten mittig im Raster, damit sie ohne Scrollen
    /// sichtbar sind und den Platz nutzen. Lange Antworten bleiben eine Liste.
    private var textColumns: Int {
        guard !dynamicTypeSize.isAccessibilitySize else { return 1 }
        let longest = task.options.map(\.text.count).max() ?? 0
        let count = task.options.count
        if longest <= 8 { return (count % 3 == 0 || count > 6) ? 3 : 2 }
        if longest <= 16 { return 2 }
        return 1
    }

    private var typeLabel: String {
        if task.hasImages { return "BILDAUSWAHL" }
        return allowsMultiple ? "MULTIPLE CHOICE" : "SINGLE CHOICE"
    }

    var body: some View {
        StepScaffold(step: step, session: session, typeLabel: typeLabel,
                     isSubmitted: submitted, score: score,
                     submitTitle: "Antwort bestätigen", canSubmit: !selected.isEmpty,
                     onSubmit: submit) {
            if task.hasImages {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs), GridItem(.flexible())],
                          spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs) {
                    ForEach(Array(task.options.enumerated()), id: \.offset) { i, option in
                        ImageOptionCard(option: option, state: state(of: i)) { toggle(i) }
                    }
                }
                .padding(.horizontal, DentIQ.Spacing.m)
            } else if textColumns > 1 {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: DentIQ.Spacing.s + 2),
                                         count: textColumns),
                          spacing: DentIQ.Spacing.s + 2) {
                    ForEach(Array(task.options.enumerated()), id: \.offset) { i, option in
                        ChoiceOptionRow(text: option.text, isMultiple: allowsMultiple,
                                        state: state(of: i), isCompact: true) { toggle(i) }
                    }
                }
                .padding(.horizontal, DentIQ.Spacing.m)
            } else {
                VStack(spacing: DentIQ.Spacing.s + 2) {
                    ForEach(Array(task.options.enumerated()), id: \.offset) { i, option in
                        ChoiceOptionRow(text: option.text, isMultiple: allowsMultiple,
                                        state: state(of: i)) { toggle(i) }
                    }
                }
                .padding(.horizontal, DentIQ.Spacing.m)
            }
        }
    }

    private func state(of index: Int) -> OptionState {
        let isSelected = selected.contains(index)
        guard submitted else { return isSelected ? .selected : .idle }
        // Richtig und angekreuzt = Teal; richtig, aber vergessen = Rot
        if task.correct.contains(index) { return isSelected ? .correct : .missed }
        return isSelected ? .wrong : .idle
    }

    private func toggle(_ index: Int) {
        guard !submitted else { return }
        if allowsMultiple {
            if selected.contains(index) { selected.remove(index) } else { selected.insert(index) }
        } else {
            selected = [index]
        }
    }

    private func submit() {
        score = StepScoring.choice(selected: selected, correct: task.correct, points: step.points)
        let texts = task.options.map(\.text)
        session.record(score, for: step,
                       given: selected.sorted().map { texts[$0] }.joined(separator: ", "),
                       correct: task.correct.sorted().map { texts[$0] }.joined(separator: ", "))
        withAnimation(.easeInOut) { submitted = true }
    }
}

// MARK: - Text-Option
private struct ChoiceOptionRow: View {
    let text: String
    let isMultiple: Bool
    let state: OptionState
    /// Kompakte Kachel im Raster: Text mittig, Symbol klein oben rechts.
    var isCompact: Bool = false
    let action: () -> Void

    private var icon: String {
        switch state {
        case .idle:     return isMultiple ? "square" : "circle"
        case .selected: return isMultiple ? "checkmark.square.fill" : "largecircle.fill.circle"
        case .correct:  return "checkmark.circle.fill"
        case .wrong:    return "xmark.circle.fill"
        case .missed:   return "exclamationmark.circle.fill"
        }
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.tile, style: .continuous)
    }

    var body: some View {
        Button(action: action) {
            Group {
                if isCompact {
                    Text(text)
                        .font(state.isHighlighted ? DentIQ.Font.secondaryMedium : DentIQ.Font.secondary)
                        .foregroundStyle(state.text)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.85)
                        .padding(.horizontal, DentIQ.Spacing.l - DentIQ.Spacing.xs)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .overlay(alignment: .topTrailing) {
                            if state != .idle {
                                Image(systemName: icon)
                                    .font(.caption)
                                    .foregroundStyle(state.accent)
                                    .padding(DentIQ.Spacing.s - 2)
                                    .accessibilityHidden(true)
                            }
                        }
                } else {
                    HStack(spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs) {
                        Text(text)
                            .font(state.isHighlighted ? DentIQ.Font.secondaryMedium : DentIQ.Font.secondary)
                            .foregroundStyle(state.text)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: icon)
                            .font(.body)
                            .foregroundStyle(state.accent)
                            .accessibilityHidden(true)
                    }
                    .padding(.horizontal, DentIQ.Spacing.m - 2)
                    .padding(.vertical, DentIQ.Spacing.m - DentIQ.Spacing.xs)
                }
            }
            .background(shape.fill(state.background))
            .overlay(shape.strokeBorder(state.border, lineWidth: state.isHighlighted ? 1.5 : DentIQ.Spacing.hairline))
            .contentShape(shape)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.25), value: state)
        .sensoryFeedback(.selection, trigger: state == .selected)
        .accessibilityValue(accessibilityState)
    }

    private var accessibilityState: String {
        switch state {
        case .idle: ""
        case .selected: "Ausgewählt"
        case .correct: "Richtig"
        case .wrong: "Falsch"
        case .missed: "Richtig, aber nicht ausgewählt"
        }
    }
}

// MARK: - Bild-Option (z. B. Röntgenbilder)
private struct ImageOptionCard: View {
    let option: ChoiceTask.Option
    let state: OptionState
    let action: () -> Void
    @State private var showZoom = false

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.tile, style: .continuous)
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: DentIQ.Spacing.s) {
                if let image = option.image {
                    // Feste Fläche in Spaltenbreite; das Bild passt sich ein (scaledToFit),
                    // wird also vollständig gezeigt und kann die Karte nicht verbreitern.
                    Color.clear
                        .frame(maxWidth: .infinity)
                        .frame(height: 150)
                        .overlay {
                            Image(image)
                                .resizable()
                                .scaledToFit()
                        }
                        .background(DentIQ.Color.groupedSurface)
                        .clipShape(RoundedRectangle(cornerRadius: DentIQ.Radius.tile - DentIQ.Spacing.s,
                                                    style: .continuous))
                        .overlay(alignment: .bottomTrailing) {
                            Button(action: { showZoom = true }) { ZoomBadge() }
                                .accessibilityLabel("\(option.text) vergrößern")
                        }
                }
                HStack(spacing: DentIQ.Spacing.xs) {
                    if state == .correct || state == .wrong || state == .missed {
                        Image(systemName: state == .correct ? "checkmark.circle.fill"
                              : state == .missed ? "exclamationmark.circle.fill" : "xmark.circle.fill")
                            .foregroundStyle(state.accent)
                    }
                    Text(option.text)
                        .font(state.isHighlighted ? DentIQ.Font.secondaryMedium : DentIQ.Font.secondary)
                        .foregroundStyle(state.text)
                        .multilineTextAlignment(.center)
                        // Immer zwei Zeilen Platz, damit beide Karten gleich hoch sind
                        .lineLimit(2, reservesSpace: true)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(DentIQ.Spacing.s)
            .frame(maxWidth: .infinity)
            .background(shape.fill(state.background))
            .overlay(shape.strokeBorder(state.border, lineWidth: state.isHighlighted ? 2 : DentIQ.Spacing.hairline))
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showZoom) {
            if let image = option.image {
                ZoomableImageView(imageName: image, caption: option.text)
            }
        }
    }
}
