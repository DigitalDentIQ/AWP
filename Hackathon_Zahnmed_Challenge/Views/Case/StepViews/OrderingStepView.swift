import SwiftUI

// MARK: - STEP: SORTIERAUFGABE
struct OrderingStepView: View {
    let step: CaseStep
    let task: OrderingTask
    @ObservedObject var session: CaseSession
    @State private var items: [SortItem]
    @State private var submitted = false
    @State private var score = 0
    /// Feste Zeilenhöhe (wächst mit Dynamic Type), damit die Liste ihre Höhe ohne Messen kennt.
    @ScaledMetric(relativeTo: .subheadline) private var rowHeight: CGFloat = 60
    private let rowSpacing: CGFloat = 10

    init(step: CaseStep, task: OrderingTask, session: CaseSession) {
        self.step = step
        self.task = task
        _session = ObservedObject(wrappedValue: session)
        _items = State(initialValue: Self.shuffled(task.items))
    }

    var body: some View {
        StepScaffold(step: step, session: session, typeLabel: "SORTIERAUFGABE",
                     isSubmitted: submitted, score: score,
                     submitTitle: "Reihenfolge bestätigen", canSubmit: true,
                     onSubmit: submit) {
            // Ziehen über den Griff rechts in jeder Karte (System-Sortierung)
            List {
                ForEach(items) { item in
                    SortRowView(
                        item: item, rank: rankOf(item),
                        submitted: submitted, isCorrect: rankOf(item) == item.correctRank,
                        onMoveUp: { move(item, by: -1) }, onMoveDown: { move(item, by: 1) },
                        showsArrows: false, drawsBackground: false
                    )
                    .frame(height: rowHeight)
                    .listRowInsets(EdgeInsets(top: rowSpacing / 2, leading: DentIQ.Spacing.m - DentIQ.Spacing.xs,
                                              bottom: rowSpacing / 2, trailing: DentIQ.Spacing.m - DentIQ.Spacing.xs))
                    // Karte als Zeilenhintergrund, damit der Zieh-Griff mit in der Karte sitzt
                    .listRowBackground(rowBackground(for: item).padding(.vertical, rowSpacing / 2))
                    .listRowSeparator(.hidden)
                }
                .onMove { from, to in
                    guard !submitted else { return }
                    withAnimation(.spring(response: 0.3)) { items.move(fromOffsets: from, toOffset: to) }
                }
                .moveDisabled(submitted)
                .deleteDisabled(true)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .scrollDisabled(true)
            .contentMargins(.vertical, 0, for: .scrollContent)
            .environment(\.editMode, .constant(submitted ? .inactive : .active))
            .frame(height: CGFloat(items.count) * (rowHeight + rowSpacing))
            .sensoryFeedback(.selection, trigger: items.map(\.id))
            .padding(.horizontal, DentIQ.Spacing.m)
        }
    }

    /// Kartenfläche einer Zeile: neutral, nach dem Bestätigen Teal (richtig) oder Rot (falsch).
    private func rowBackground(for item: SortItem) -> some View {
        let state: OptionState = submitted ? (rankOf(item) == item.correctRank ? .correct : .wrong) : .idle
        let shape = RoundedRectangle(cornerRadius: DentIQ.Radius.tile, style: .continuous)
        return shape.fill(state.background)
            .overlay(shape.strokeBorder(state.border, lineWidth: state.isHighlighted ? 1.5 : DentIQ.Spacing.hairline))
    }

    /// Mischt die Elemente so, dass sie nicht schon in der richtigen Reihenfolge starten.
    private static func shuffled(_ labels: [String]) -> [SortItem] {
        let items = labels.enumerated().map { SortItem(id: UUID(), label: $1, correctRank: $0 + 1) }
        guard items.count > 1 else { return items }
        var result = items.shuffled()
        while result.map(\.correctRank) == items.map(\.correctRank) { result.shuffle() }
        return result
    }

    private func rankOf(_ item: SortItem) -> Int {
        (items.firstIndex(where: { $0.id == item.id }) ?? 0) + 1
    }

    private func move(_ item: SortItem, by offset: Int) {
        guard !submitted,
              let idx = items.firstIndex(where: { $0.id == item.id }),
              items.indices.contains(idx + offset) else { return }
        withAnimation(.spring(response: 0.3)) { items.swapAt(idx, idx + offset) }
    }

    private func submit() {
        score = StepScoring.ordering(current: items.map(\.label), correct: task.items, points: step.points)
        session.record(score, for: step,
                       given: items.map(\.label).joined(separator: " → "),
                       correct: task.items.joined(separator: " → "))
        withAnimation(.easeInOut) { submitted = true }
    }
}
