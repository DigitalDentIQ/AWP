import SwiftUI

// MARK: - PROFIL (eigene Seite)
/// Alles, was zu einem selbst gehört: Nickname, Sichtbarkeit im Ranking, Punkte, Rang,
/// Fortschritt je Fall und Zurücksetzen. Wird von der Startseite (oben rechts) und aus dem Ranking geöffnet.
struct ProfileView: View {
    @EnvironmentObject private var backend: BackendService
    @EnvironmentObject private var appState: AppState
    @State private var nickname = ""
    @State private var showInRanking = true
    @State private var isSaving = false
    @State private var errorMessage: String?
    @State private var didSave = false
    @State private var confirmReset = false
    @State private var rank: Int?
    @FocusState private var nicknameFocused: Bool

    private var trimmedNickname: String {
        nickname.trimmingCharacters(in: .whitespaces)
    }

    private var isNicknameValid: Bool {
        trimmedNickname.range(of: "^[A-Za-z0-9_.-]{3,20}$", options: .regularExpression) != nil
    }

    /// Gibt es ungesicherte Änderungen?
    private var hasChanges: Bool {
        trimmedNickname != (backend.profile?.nickname ?? "")
            || showInRanking != (backend.profile?.showInRanking ?? true)
    }

    var body: some View {
        Form {
            header

            Section {
                HStack(alignment: .top, spacing: DentIQ.Spacing.m) {
                    KPIView(value: appState.userScore.formatted(), label: "Punkte", alignment: .center)
                    KPIView(value: "\(appState.completedCaseIDs.count)/\(appState.cases.count)", label: "Fälle gelöst",
                            alignment: .center)
                    KPIView(value: rank.map { "#\($0)" } ?? "–", label: "Rang", alignment: .center)
                }
                .padding(.vertical, DentIQ.Spacing.xs)
            }
            .listRowBackground(DentIQ.Color.groupedSurface)

            Section {
                TextField("Nickname", text: $nickname)
                    .font(DentIQ.Font.body)
                    .foregroundStyle(DentIQ.Color.textPrimary)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($nicknameFocused)
                    .submitLabel(.done)
                    .onSubmit { if isNicknameValid && hasChanges { save() } }
                Toggle("Im Ranking anzeigen", isOn: $showInRanking)
                    .font(DentIQ.Font.body)
                    .foregroundStyle(DentIQ.Color.textPrimary)
                    .tint(DentIQ.Color.accent)
                if let errorMessage {
                    Label(errorMessage, systemImage: "exclamationmark.triangle")
                        .font(DentIQ.Font.secondary)
                        .foregroundStyle(DentIQ.Color.error)
                }
            } header: {
                sectionHeader("Ranking")
            } footer: {
                Text("3–20 Zeichen: Buchstaben, Zahlen, _ . -  Andere sehen nur deinen Nickname und deine Punkte.")
                    .font(DentIQ.Font.meta)
                    .foregroundStyle(DentIQ.Color.textSecondary)
            }
            .listRowBackground(DentIQ.Color.groupedSurface)

            Section {
                ForEach(appState.cases) { patientCase in
                    caseRow(patientCase)
                }
                Button("Fortschritt zurücksetzen", role: .destructive) { confirmReset = true }
                    .font(DentIQ.Font.body)
                    .disabled(appState.completedCaseIDs.isEmpty)
            } header: {
                sectionHeader("Fortschritt")
            }
            .listRowBackground(DentIQ.Color.groupedSurface)

            Section {
                LabeledContent {
                    Text(statusText)
                        .font(DentIQ.Font.secondary)
                        .foregroundStyle(DentIQ.Color.textSecondary)
                } label: {
                    Text("Verbindung")
                        .font(DentIQ.Font.body)
                        .foregroundStyle(DentIQ.Color.textPrimary)
                }
            } header: {
                sectionHeader("Konto")
            } footer: {
                Text("Dein Fortschritt wird anonym gespeichert. Anmeldung per E-Mail folgt, damit du ihn auf andere Geräte mitnehmen kannst.")
                    .font(DentIQ.Font.meta)
                    .foregroundStyle(DentIQ.Color.textSecondary)
            }
            .listRowBackground(DentIQ.Color.groupedSurface)
        }
        .scrollContentBackground(.hidden)
        .background(DentIQ.Color.groupedBackground)
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                if isSaving {
                    ProgressView()
                } else {
                    Button("Sichern", action: save)
                        .disabled(!isNicknameValid || !hasChanges || !backend.isReady)
                }
            }
        }
        .confirmationDialog("Gesamten Fortschritt zurücksetzen?",
                            isPresented: $confirmReset, titleVisibility: .visible) {
            Button("Alle Fälle zurücksetzen", role: .destructive) { appState.resetAllProgress() }
        } message: {
            Text("Alle Fälle werden wieder als offen angezeigt. Deine Ergebnisse im Ranking bleiben erhalten.")
        }
        .sensoryFeedback(.success, trigger: didSave)
        .onAppear {
            nickname = backend.profile?.nickname ?? ""
            showInRanking = backend.profile?.showInRanking ?? true
        }
        .task { await loadRank() }
    }

    // MARK: Bausteine

    /// Avatar, Name und Status oben, ohne Kartenfläche.
    private var header: some View {
        Section {
            VStack(spacing: DentIQ.Spacing.s) {
                RankingAvatar(name: backend.profile?.nickname ?? "?", size: 72)
                Text(backend.profile?.nickname ?? "Noch kein Nickname")
                    .font(DentIQ.Font.heading)
                    .foregroundStyle(DentIQ.Color.textPrimary)
                Text(statusText)
                    .font(DentIQ.Font.meta)
                    .foregroundStyle(DentIQ.Color.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .accessibilityElement(children: .combine)
        }
        .listRowBackground(Color.clear)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title.uppercased())
            .font(DentIQ.Font.eyebrow)
            .tracking(DentIQ.Font.eyebrowTracking)
            .foregroundStyle(DentIQ.Color.textSecondary)
    }

    private func caseRow(_ patientCase: PatientCase) -> some View {
        let isCompleted = appState.isCompleted(patientCase)
        return HStack(spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs) {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isCompleted ? DentIQ.Color.accent : DentIQ.Color.textMuted)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(patientCase.title)
                    .font(DentIQ.Font.secondaryMedium)
                    .foregroundStyle(DentIQ.Color.textPrimary)
                Text(patientCase.category)
                    .font(DentIQ.Font.meta)
                    .foregroundStyle(DentIQ.Color.textSecondary)
            }
            Spacer()
            Text(isCompleted
                 ? "\(appState.bestScore(for: patientCase) ?? 0) / \(patientCase.maxScore)"
                 : "Offen")
                .font(DentIQ.Font.number)
                .monospacedDigit()
                .foregroundStyle(isCompleted ? DentIQ.Color.accent : DentIQ.Color.textSecondary)
        }
        .accessibilityElement(children: .combine)
    }

    private var statusText: String {
        switch backend.status {
        case .idle, .connecting: return "Verbinde…"
        case .ready:             return "Verbunden"
        case .failed:            return "Offline"
        }
    }

    // MARK: Aktionen

    private func save() {
        isSaving = true
        errorMessage = nil
        nicknameFocused = false
        Task {
            do {
                try await backend.updateProfile(nickname: trimmedNickname, showInRanking: showInRanking)
                didSave.toggle()
                await loadRank()
            } catch {
                // 23505 = unique_violation in PostgreSQL
                errorMessage = "\(error)".contains("23505")
                    ? "Dieser Nickname ist schon vergeben."
                    : "Speichern fehlgeschlagen. Bitte später erneut versuchen."
            }
            isSaving = false
        }
    }

    /// Eigenen Rang aus dem Ranking lesen (falls sichtbar und vorhanden).
    private func loadRank() async {
        guard let own = backend.profile?.nickname,
              let entries = try? await backend.leaderboard() else { return }
        rank = entries.first { $0.nickname == own }?.rank
    }
}
