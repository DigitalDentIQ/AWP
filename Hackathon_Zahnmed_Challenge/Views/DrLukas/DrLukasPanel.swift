import SwiftUI

// MARK: - DR. LUKAS PANEL (in jedem Schritt)
// Aufklappbarer Tipp aus den Falldaten + "Frag Dr. Lukas" bzw. nach dem Beantworten
// "Warum war das falsch?".
struct DrLukasPanel: View {
    let step: CaseStep
    @ObservedObject var session: CaseSession
    let isSubmitted: Bool
    let score: Int

    @State private var showHint = false
    @State private var chat: ChatRequest?

    private struct ChatRequest: Identifiable {
        let id = UUID()
        let mode: DrLukasChatView.Mode
        /// Steht beim Öffnen schon im Eingabefeld.
        var prefill: String? = nil
    }

    private var answer: (given: String, correct: String)? { session.answers[step.id] }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.tile, style: .continuous)
    }

    /// Gleicher Stil wie der Expertenkommentar: Mint-Fläche, Teal-Kante links.
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let hint = step.drLukasHint {
                Button(action: { withAnimation { showHint.toggle() } }) {
                    HStack(spacing: DentIQ.Spacing.s) {
                        Image("dr_lukas")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            .background(DentIQ.Color.groupedSurface)
                            .clipShape(Circle())
                            .accessibilityHidden(true)
                        Text("Expertenkommentar")
                            .font(DentIQ.Font.secondaryMedium)
                            .foregroundStyle(DentIQ.Color.textPrimary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(DentIQ.Color.accent)
                            .rotationEffect(.degrees(showHint ? 90 : 0))
                            .accessibilityHidden(true)
                    }
                    .padding(.vertical, DentIQ.Spacing.m - DentIQ.Spacing.xs)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityValue(showHint ? "Aufgeklappt" : "Zugeklappt")
                if showHint {
                    Text(hint)
                        .font(DentIQ.Font.secondary)
                        .foregroundStyle(DentIQ.Color.textPrimary)
                        .lineSpacing(4)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, DentIQ.Spacing.m - DentIQ.Spacing.xs)
                }
                HairlineDivider()
            }

            Button(action: openChat) {
                HStack(spacing: DentIQ.Spacing.s) {
                    Image(systemName: actionIcon)
                        .foregroundStyle(DentIQ.Color.accent)
                        .frame(width: 24)
                        .accessibilityHidden(true)
                    Text(actionTitle)
                        .font(DentIQ.Font.secondaryMedium)
                        .foregroundStyle(DentIQ.Color.textPrimary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(DentIQ.Color.accent)
                        .accessibilityHidden(true)
                }
                .padding(.vertical, DentIQ.Spacing.m - DentIQ.Spacing.xs)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, DentIQ.Spacing.m - 2)
        .padding(.leading, DentIQ.Spacing.xs)
        .background(shape.fill(DentIQ.Color.surfaceAccent))
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(DentIQ.Color.accent)
                .frame(width: 3)
        }
        .clipShape(shape)
        .padding(.horizontal, DentIQ.Spacing.m)
        .sheet(item: $chat) { request in
            DrLukasChatView(mode: request.mode, patientCase: session.patientCase, prefill: request.prefill)
        }
    }

    private var canExplain: Bool { isSubmitted && answer != nil }

    private var actionTitle: String {
        guard canExplain else { return "Frag Dr. Lukas" }
        return score < step.points ? "Warum war das falsch? Dr. Lukas erklärt" : "Mehr dazu von Dr. Lukas"
    }

    private var actionIcon: String {
        canExplain ? "lightbulb" : "bubble.left.and.text.bubble.right"
    }

    private func openChat() {
        var context = StepContext(step: step)
        if canExplain, let answer {
            context.givenAnswer = answer.given
            context.correctAnswer = answer.correct
            context.expertComment = step.expertComment
            chat = ChatRequest(mode: .explain(context))
        } else {
            // Frage des Schritts schon ins Eingabefeld, damit man direkt senden kann
            chat = ChatRequest(mode: .ask(context), prefill: step.question)
        }
    }
}
