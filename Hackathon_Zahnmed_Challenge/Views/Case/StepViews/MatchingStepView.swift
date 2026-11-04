import SwiftUI

// MARK: - STEP: ZUORDNUNGSAUFGABE
struct MatchingStepView: View {
    let step: CaseStep
    let task: MatchingTask
    @ObservedObject var session: CaseSession
    @State private var selections: [String: String] = [:]
    @State private var submitted = false
    @State private var score = 0

    private var allSelected: Bool { task.pairs.allSatisfy { selections[$0.item] != nil } }

    var body: some View {
        StepScaffold(step: step, session: session, typeLabel: "ZUORDNUNGSAUFGABE",
                     isSubmitted: submitted, score: score,
                     submitTitle: "Zuordnung bestätigen", canSubmit: allSelected,
                     onSubmit: submit) {
            VStack(spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs) {
                ForEach(task.pairs, id: \.self) { pair in
                    MatchingRowView(pair: pair, answers: task.answers,
                                    selection: $selections, submitted: submitted)
                }
            }
            .padding(.horizontal, DentIQ.Spacing.m)
        }
    }

    private func submit() {
        score = StepScoring.matching(selections: selections, pairs: task.pairs, points: step.points)
        session.record(score, for: step,
                       given: task.pairs.map { "\($0.item): \(selections[$0.item] ?? "–")" }.joined(separator: "; "),
                       correct: task.pairs.map { "\($0.item): \($0.answer)" }.joined(separator: "; "))
        withAnimation(.easeInOut) { submitted = true }
    }
}

private struct MatchingRowView: View {
    let pair: MatchingTask.Pair
    let answers: [String]
    @Binding var selection: [String: String]
    let submitted: Bool

    var sel: String?  { selection[pair.item] }
    var isRight: Bool { submitted && sel == pair.answer }
    var isWrong: Bool { submitted && sel != pair.answer }

    private var state: OptionState {
        guard submitted else { return sel != nil ? .selected : .idle }
        return isRight ? .correct : .wrong
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.group, style: .continuous)
    }

    private var menuShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.tile - DentIQ.Spacing.xs, style: .continuous)
    }

    var body: some View {
        HStack(spacing: DentIQ.Spacing.m - 2) {
            Text(pair.item)
                .font(DentIQ.Font.secondaryMedium)
                .foregroundStyle(DentIQ.Color.onInverse)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding(DentIQ.Spacing.xs)
                .frame(width: 42, height: 42)
                .background(Circle().fill(DentIQ.Color.surfaceInverse))
                .overlay(Circle().strokeBorder(submitted ? state.accent : Color.clear, lineWidth: 2.5))
            VStack(alignment: .leading, spacing: 2) {
                if submitted {
                    Text(sel ?? "–")
                        .font(DentIQ.Font.secondaryMedium)
                        .foregroundStyle(DentIQ.Color.textPrimary)
                    if isWrong {
                        Text("Richtig: \(pair.answer)")
                            .font(DentIQ.Font.meta)
                            .foregroundStyle(DentIQ.Color.textSecondary)
                    }
                } else {
                    Menu {
                        ForEach(answers, id: \.self) { answer in
                            Button(answer) { selection[pair.item] = answer }
                        }
                    } label: {
                        HStack {
                            Text(sel ?? "Auswählen...")
                                .font(DentIQ.Font.secondary)
                                .foregroundStyle(sel != nil ? DentIQ.Color.textPrimary : DentIQ.Color.textMuted)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            Image(systemName: "chevron.up.chevron.down")
                                .imageScale(.small)
                                .foregroundStyle(DentIQ.Color.textSecondary)
                        }
                        .padding(.horizontal, DentIQ.Spacing.m - DentIQ.Spacing.xs)
                        .frame(minHeight: DentIQ.Spacing.minTapTarget)
                        .background(menuShape.fill(sel != nil ? DentIQ.Color.surfaceAccent : DentIQ.Color.groupedBackground))
                        .overlay(menuShape.strokeBorder(sel != nil ? DentIQ.Color.accent : DentIQ.Color.hairline,
                                                        lineWidth: DentIQ.Spacing.hairline))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            if submitted {
                Image(systemName: isRight ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.body)
                    .foregroundStyle(state.accent)
                    .accessibilityLabel(isRight ? "Richtig" : "Falsch")
            }
        }
        .padding(DentIQ.Spacing.m - DentIQ.Spacing.xs)
        .background(shape.fill(submitted ? state.background : DentIQ.Color.groupedSurface))
        .overlay(shape.strokeBorder(submitted ? state.border : DentIQ.Color.hairline,
                                    lineWidth: submitted ? 1.5 : DentIQ.Spacing.hairline))
    }
}
