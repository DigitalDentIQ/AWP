import SwiftUI

// MARK: - CASE COMPLETED VIEW
struct CaseCompletedView: View {
    @EnvironmentObject var navState: NavState
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var backend: BackendService
    @ObservedObject var session: CaseSession
    @State private var didSaveResult = false

    private var maxScore: Int { session.patientCase.maxScore }

    private var cardShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.group, style: .continuous)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: DentIQ.Spacing.l + DentIQ.Spacing.xs) {

                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 72, weight: .light))
                    .foregroundStyle(DentIQ.Color.accent)
                    .symbolEffect(.bounce, options: .nonRepeating)
                    .padding(.top, DentIQ.Spacing.xl)
                    .accessibilityHidden(true)

                VStack(spacing: DentIQ.Spacing.s) {
                    Text("Fall abgeschlossen")
                        .font(DentIQ.Font.screenTitle)
                        .foregroundStyle(DentIQ.Color.textPrimary)
                        .accessibilityAddTraits(.isHeader)
                    Text(session.patientCase.title)
                        .font(DentIQ.Font.body)
                        .foregroundStyle(DentIQ.Color.textSecondary)
                }
                .multilineTextAlignment(.center)

                VStack(spacing: DentIQ.Spacing.xs) {
                    Text("\(session.totalScore) / \(maxScore)")
                        .font(DentIQ.Font.kpi)
                        .monospacedDigit()
                        .foregroundStyle(DentIQ.Color.accent)
                    Text("Punkte")
                        .font(DentIQ.Font.bodyMedium)
                        .foregroundStyle(DentIQ.Color.textPrimary)
                    if let best = appState.bestScore(for: session.patientCase), best > session.totalScore {
                        Text("Dein Bestes: \(best)")
                            .font(DentIQ.Font.meta)
                            .foregroundStyle(DentIQ.Color.textSecondary)
                    }
                }
                .padding(.horizontal, DentIQ.Spacing.xl)
                .padding(.vertical, DentIQ.Spacing.m)
                .background(Capsule().fill(DentIQ.Color.surfaceAccent))
                .accessibilityElement(children: .combine)

                if let feedback = session.aiFeedback {
                    VStack(alignment: .center, spacing: DentIQ.Spacing.s + 2) {
                        Label {
                            Text("KI-Auswertung").foregroundStyle(DentIQ.Color.textPrimary)
                        } icon: {
                            Image(systemName: "brain.head.profile").foregroundStyle(DentIQ.Color.accent)
                        }
                        .font(DentIQ.Font.bodyMedium)

                        Text(feedback)
                            .font(DentIQ.Font.secondary)
                            .foregroundStyle(DentIQ.Color.textPrimary)
                            .lineSpacing(5)
                            .multilineTextAlignment(.center)
                            .padding(DentIQ.Spacing.m)
                            .frame(maxWidth: .infinity, minHeight: 160, alignment: .top)
                            .background(
                                RoundedRectangle(cornerRadius: DentIQ.Radius.tile, style: .continuous)
                                    .fill(DentIQ.Color.surfaceAccent)
                            )
                            .textSelection(.enabled)
                    }
                    .padding(DentIQ.Spacing.m + DentIQ.Spacing.xs)
                    .background(cardShape.fill(DentIQ.Color.groupedSurface))
                    .dentIQElevation(in: cardShape)
                    .padding(.horizontal, DentIQ.Spacing.m)
                }

                VStack(spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs) {
                    Button(action: session.restart) {
                        HStack(spacing: DentIQ.Spacing.s) {
                            Text("Fall wiederholen")
                            Image(systemName: "arrow.counterclockwise")
                        }
                    }
                    .buttonStyle(.dentIQPrimary)
                    Button(action: navState.goHome) {
                        Label("Zur Startseite", systemImage: "house")
                    }
                    .buttonStyle(.dentIQSecondary)
                }
                .padding(.horizontal, DentIQ.Spacing.m)

                Spacer(minLength: DentIQ.Spacing.xl)
            }
        }
        .sensoryFeedback(.success, trigger: didSaveResult)
        .onAppear {
            guard !didSaveResult else { return }
            didSaveResult = true
            appState.recordCompletion(session.patientCase, score: session.totalScore)
            Task { await backend.saveCompletedCase(session) }
        }
    }
}
