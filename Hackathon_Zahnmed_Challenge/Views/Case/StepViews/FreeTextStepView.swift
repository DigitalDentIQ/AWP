import SwiftUI

// MARK: - STEP: FREITEXT
struct FreeTextStepView: View {
    let step: CaseStep
    let task: FreeTextTask
    @ObservedObject var session: CaseSession
    @State private var inputText = ""
    @FocusState private var editorFocused: Bool

    private var editorShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.tile, style: .continuous)
    }

    private var wordCount: Int {
        inputText.split(whereSeparator: \.isWhitespace).count
    }

    private var matchedKeywords: [String] {
        let normalizedText = inputText.folding(
            options: [.diacriticInsensitive, .caseInsensitive],
            locale: .current
        )

        return task.keywords.filter { normalizedText.contains($0) }
    }

    private var hasEnoughWords: Bool { wordCount >= task.minWords }

    private var isAnswerValid: Bool {
        hasEnoughWords && matchedKeywords.count >= 2
    }

    private var validationMessage: String? {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }

        if !hasEnoughWords {
            return "Formuliere bitte mindestens \(task.minWords) Wörter."
        }

        if matchedKeywords.count < 2 {
            return "Interessanter Ansatz. Vergleiche deine Überlegungen noch mit dem Hinweis von Dr. Lukas, bevor du weitergehst."
        }

        return "Gute erste Einschätzung – du kannst fortfahren."
    }

    var body: some View {
        StepScaffold(step: step, session: session, typeLabel: "OFFENE FRAGE",
                     isSubmitted: false, score: 0,
                     submitTitle: "Weiter", canSubmit: hasEnoughWords,
                     onSubmit: session.advance) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $inputText)
                    .font(DentIQ.Font.secondary)
                    .foregroundStyle(DentIQ.Color.textPrimary)
                    .scrollContentBackground(.hidden)
                    .focused($editorFocused)
                    .frame(height: 140)
                    .padding(DentIQ.Spacing.m - DentIQ.Spacing.xs)
                    .background(editorShape.fill(DentIQ.Color.groupedSurface))
                    .overlay(
                        editorShape.strokeBorder(
                            editorFocused ? DentIQ.Color.accent : DentIQ.Color.hairline,
                            lineWidth: editorFocused ? 1.5 : DentIQ.Spacing.hairline
                        )
                    )
                    .onChange(of: inputText) { _, newValue in
                        if newValue.count > task.maxLength {
                            inputText = String(newValue.prefix(task.maxLength))
                        }
                    }
                if inputText.isEmpty {
                    Text("Ihre Überlegungen hier eingeben...")
                        .font(DentIQ.Font.secondary)
                        .foregroundStyle(DentIQ.Color.textMuted)
                        .padding(DentIQ.Spacing.m + DentIQ.Spacing.xs)
                        .allowsHitTesting(false)
                        .accessibilityHidden(true)
                }
            }
            .padding(.horizontal, DentIQ.Spacing.m)

            Text("\(inputText.count) / \(task.maxLength)")
                .font(DentIQ.Font.meta)
                .monospacedDigit()
                .foregroundStyle(DentIQ.Color.textSecondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, DentIQ.Spacing.m)

            if let validationMessage {
                Label {
                    Text(validationMessage).foregroundStyle(DentIQ.Color.textPrimary)
                } icon: {
                    Image(systemName: isAnswerValid ? "checkmark.circle.fill" : "info.circle.fill")
                        .foregroundStyle(DentIQ.Color.accent)
                }
                .font(DentIQ.Font.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, DentIQ.Spacing.m)
            }
        }
    }
}
