import SwiftUI

// MARK: - STEP SCAFFOLD
// Gemeinsamer Rahmen aller Schritte: Fortschritt, Fall-Update, Frage, Bild, Befund,
// Aufgabe, Expertenkommentar, Dr.-Lukas-Tipp und Bestätigen/Weiter-Button.
struct StepScaffold<Content: View>: View {
    let step: CaseStep
    @ObservedObject var session: CaseSession
    let typeLabel: String
    let isSubmitted: Bool
    let score: Int
    let submitTitle: String
    let canSubmit: Bool
    /// Läuft die Abgabe gerade (z. B. KI-Auswertung)?
    var isBusy: Bool = false
    let onSubmit: () -> Void
    @ViewBuilder let content: Content

    var body: some View {
        // Alles ist normaler Seiteninhalt (kein Overlay). PinnedBottomLayout setzt Dr. Lukas
        // und den Button an den unteren Rand des Bildschirms; bei langem Inhalt stehen sie
        // nach dem Inhalt und die Seite scrollt.
        GeometryReader { proxy in
            ScrollView {
                PinnedBottomLayout(minHeight: proxy.size.height, minGap: DentIQ.Spacing.l) {
                    VStack(spacing: DentIQ.Spacing.m) {
                        ProgressBarView(step: session.stepNumber,
                                        total: session.patientCase.totalSteps,
                                        points: session.totalScore)
                            .padding(.bottom, DentIQ.Spacing.s)
                        taskArea
                    }
                    .padding(.top, DentIQ.Spacing.s)

                    VStack(spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs) {
                        DrLukasPanel(step: step, session: session, isSubmitted: isSubmitted, score: score)
                        actionButton
                    }
                    .padding(.bottom, DentIQ.Spacing.m)
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .animation(.easeInOut, value: isSubmitted)
        .sensoryFeedback(trigger: isSubmitted) { _, submitted in
            guard submitted, step.points > 0 else { return nil }
            return score > 0 ? .success : .error
        }
    }

    /// Frage, Material, Aufgabe und Rückmeldung.
    private var taskArea: some View {
        VStack(spacing: DentIQ.Spacing.m) {
            if let context = step.context {
                CaseUpdateView(text: context)
            }

            QuestionCardView(
                typeLabel: typeLabel,
                question: step.question, subtitle: step.instruction
            )

            if let media = step.media {
                StepMediaView(media: media)
            }

            if let facts = step.facts, !facts.isEmpty {
                FactsGridView(facts: facts)
            }

            content

            if isSubmitted {
                if let comment = step.expertComment {
                    ExpertCommentView(score: score, text: comment)
                        .padding(.horizontal, DentIQ.Spacing.m)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                } else if step.points > 0 {
                    Text("\(score) von \(step.points) Punkten")
                        .font(DentIQ.Font.secondaryMedium)
                        .foregroundStyle(score > 0 ? DentIQ.Color.accent : DentIQ.Color.textSecondary)
                }
            }
        }
    }

    /// Bestätigen bzw. Weiter. Erscheint an Ort und Stelle, ohne hereinzufliegen.
    private var actionButton: some View {
        Group {
            if isSubmitted {
                Button(action: session.advance) {
                    HStack(spacing: DentIQ.Spacing.s) {
                        Text("Weiter")
                        Image(systemName: "arrow.right")
                    }
                }
                .buttonStyle(.dentIQPrimary)
                .padding(.horizontal, DentIQ.Spacing.m)
            } else {
                ConfirmButton(title: submitTitle, icon: "checkmark",
                              enabled: canSubmit, isBusy: isBusy, action: onSubmit)
            }
        }
        .transaction { $0.animation = nil }
    }
}

// MARK: - Fall-Update (neue Information im Verlauf)
private struct CaseUpdateView: View {
    let text: String

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.tile, style: .continuous)
    }

    var body: some View {
        HStack(alignment: .top, spacing: DentIQ.Spacing.s + 2) {
            Image(systemName: "doc.text.magnifyingglass")
                .foregroundStyle(DentIQ.Color.accent)
                .accessibilityHidden(true)
            Text(text)
                .font(DentIQ.Font.secondary)
                .foregroundStyle(DentIQ.Color.textPrimary)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(DentIQ.Spacing.m - 2)
        .background(shape.fill(DentIQ.Color.groupedSurface))
        .overlay(shape.strokeBorder(DentIQ.Color.hairline, lineWidth: DentIQ.Spacing.hairline))
        .padding(.horizontal, DentIQ.Spacing.m)
    }
}

// MARK: - Bild zum Schritt (antippen zum Vergrößern)
private struct StepMediaView: View {
    let media: CaseStep.Media
    @State private var showZoom = false

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.tile, style: .continuous)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DentIQ.Spacing.s - 2) {
            Button(action: { showZoom = true }) {
                Image(media.image)
                    .resizable().scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(shape)
                    .overlay(alignment: .bottomTrailing) { ZoomBadge() }
            }
            .buttonStyle(.plain)
            .accessibilityLabel(media.caption ?? "Bild vergrößern")
            if let caption = media.caption {
                Text(caption)
                    .font(DentIQ.Font.meta)
                    .foregroundStyle(DentIQ.Color.textSecondary)
            }
        }
        .padding(.horizontal, DentIQ.Spacing.m)
        .sheet(isPresented: $showZoom) {
            ZoomableImageView(imageName: media.image, caption: media.caption)
        }
    }
}

// MARK: - Befund-Tabelle (z. B. PSI-Werte)
private struct FactsGridView: View {
    let facts: [CaseStep.Fact]

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.tile, style: .continuous)
    }

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: DentIQ.Spacing.s + 2), count: 3),
                  spacing: DentIQ.Spacing.s + 2) {
            ForEach(facts, id: \.self) { fact in
                VStack(spacing: DentIQ.Spacing.xs) {
                    Text(fact.label.uppercased())
                        .font(DentIQ.Font.eyebrow)
                        .tracking(DentIQ.Font.eyebrowTracking)
                        .foregroundStyle(DentIQ.Color.textSecondary)
                    Text(fact.value)
                        .font(DentIQ.Font.subheading)
                        .monospacedDigit()
                        .foregroundStyle(DentIQ.Color.accent)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, DentIQ.Spacing.m - DentIQ.Spacing.xs)
                .background(shape.fill(DentIQ.Color.groupedSurface))
                .overlay(shape.strokeBorder(DentIQ.Color.hairline, lineWidth: DentIQ.Spacing.hairline))
                .accessibilityElement(children: .combine)
            }
        }
        .padding(.horizontal, DentIQ.Spacing.m)
    }
}
