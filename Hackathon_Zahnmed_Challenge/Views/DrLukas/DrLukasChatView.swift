import SwiftUI

// MARK: - DR. LUKAS CHAT
/// Chat mit Dr. Lukas. Läuft als eigener Tab (`isEmbedded`) oder als Fenster aus einem Fall heraus.
struct DrLukasChatView: View {
    enum Mode {
        /// Fragen stellen – zu einem Schritt (ohne Lösung) oder allgemein (step == nil)
        case ask(StepContext?)
        /// Nach dem Beantworten: Erklärung, warum die Antwort richtig/falsch ist
        case explain(StepContext)
    }

    let mode: Mode
    var patientCase: PatientCase? = nil
    var greetingName: String? = nil
    /// true im Tab „Dr. Lukas“: kein „Fertig“-Button, dafür App-Tour oben rechts.
    var isEmbedded: Bool = false
    /// Text, der beim Öffnen schon im Eingabefeld steht (z. B. die Frage des aktuellen Schritts).
    var prefill: String? = nil

    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var messages: [DrLukasService.ChatMessage] = []
    @State private var input = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var didPrefill = false
    @FocusState private var inputFocused: Bool

    private var isExplain: Bool {
        if case .explain = mode { return true }
        return false
    }

    private var intro: String {
        switch mode {
        case .ask(.some):
            return "Frag mich alles zur aktuellen Aufgabe. Ich gebe dir Denkanstöße – die Lösung erkläre ich dir aber erst, wenn du geantwortet hast."
        case .ask(.none):
            let name = greetingName.map { " \($0)" } ?? ""
            return "Hallo\(name)! Ich bin Dr. Lukas. Frag mich zur Zahnmedizin, zu den Fällen oder zur App."
        case .explain:
            return "Schauen wir uns deine Antwort gemeinsam an."
        }
    }

    private var suggestions: [String] {
        switch mode {
        case .ask(.some):
            return ["Gib mir einen Denkanstoß", "Erklär mir die Fachbegriffe", "Worauf muss ich achten?"]
        case .ask(.none):
            return ["Wie funktioniert die App?", "Was bedeutet der PSI?", "Wie lerne ich Traumatologie am besten?"]
        case .explain:
            return ["Kannst du das einfacher erklären?", "Gibt es eine Eselsbrücke?"]
        }
    }

    /// Beim ersten Besuch im Tab bietet Dr. Lukas die App-Tour an.
    private var showsTourOffer: Bool {
        isEmbedded && !appState.hasSeenTour && messages.isEmpty
    }

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: DentIQ.Spacing.m) {
                        ChatBubble(role: .assistant, text: intro)
                        if showsTourOffer {
                            tourOffer
                        }
                        ForEach(messages) { message in
                            ChatBubble(role: message.role, text: message.text)
                        }
                        if isLoading {
                            HStack(spacing: DentIQ.Spacing.s) {
                                ProgressView()
                                Text("Dr. Lukas denkt nach…")
                                    .font(DentIQ.Font.secondary)
                                    .foregroundStyle(DentIQ.Color.textSecondary)
                            }
                            .padding(.leading, ChatBubble.avatarInset)
                        }
                        if let errorMessage {
                            VStack(spacing: DentIQ.Spacing.xs) {
                                Image(systemName: "exclamationmark.triangle")
                                Text(errorMessage)
                                    .multilineTextAlignment(.center)
                            }
                            .font(DentIQ.Font.secondary)
                            .foregroundStyle(DentIQ.Color.error)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, DentIQ.Spacing.s)
                        }
                        Color.clear.frame(height: 1).id("bottom")
                    }
                    .padding(.horizontal, DentIQ.Spacing.m)
                    .padding(.vertical, DentIQ.Spacing.l)
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: messages.count) { _, _ in
                    withAnimation { proxy.scrollTo("bottom", anchor: .bottom) }
                }
                .onChange(of: isLoading) { _, _ in
                    withAnimation { proxy.scrollTo("bottom", anchor: .bottom) }
                }
            }
            .background(DentIQ.Color.background)
            // Eingabe als Leiste: System reserviert den Platz und blendet Inhalte weich aus
            .safeAreaBar(edge: .bottom) { inputArea }
            .navigationTitle("Dr. Lukas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if isEmbedded {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            appState.activeSheet = .tour
                        } label: {
                            Image(systemName: "questionmark.circle")
                        }
                        .accessibilityLabel("App-Tour")
                    }
                } else {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Fertig") { dismiss() }
                    }
                }
            }
            .onAppear {
                // Nur einmal vorbefüllen, nicht nach jedem Senden erneut
                guard !didPrefill else { return }
                didPrefill = true
                if let prefill, input.isEmpty { input = prefill }
            }
            .task {
                // Im Erklär-Modus legt Dr. Lukas direkt los
                if isExplain && messages.isEmpty { await send(nil) }
            }
        }
    }

    private var tourOffer: some View {
        VStack(alignment: .leading, spacing: DentIQ.Spacing.m) {
            Text("Soll ich dir die App kurz erklären?")
                .font(DentIQ.Font.body)
                .foregroundStyle(DentIQ.Color.textPrimary)
            HStack(spacing: DentIQ.Spacing.m) {
                Button("Ja, zeig mir alles") { appState.activeSheet = .tour }
                    .buttonStyle(.dentIQSecondary)
                Button("Kenne ich schon") { appState.markTourSeen() }
                    .buttonStyle(.dentIQLink)
                    .fixedSize()
            }
        }
        .padding(.leading, ChatBubble.avatarInset)
    }

    private var inputArea: some View {
        VStack(spacing: DentIQ.Spacing.s) {
            if !isLoading && messages.filter({ $0.role == .user }).count < 2 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DentIQ.Spacing.s) {
                        ForEach(suggestions, id: \.self) { suggestion in
                            Button(suggestion) { Task { await send(suggestion) } }
                                .buttonStyle(SuggestionChipStyle())
                        }
                    }
                    .padding(.horizontal, DentIQ.Spacing.m)
                }
            }
            HStack(alignment: .bottom, spacing: DentIQ.Spacing.s) {
                TextField("Frage an Dr. Lukas…", text: $input, axis: .vertical)
                    .lineLimit(1...4)
                    .focused($inputFocused)
                    .font(DentIQ.Font.body)
                    .foregroundStyle(DentIQ.Color.textPrimary)
                    .padding(.horizontal, DentIQ.Spacing.m)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(DentIQ.Color.surface)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .strokeBorder(
                                inputFocused ? DentIQ.Color.accent : DentIQ.Color.hairline,
                                lineWidth: DentIQ.Spacing.hairline
                            )
                    )
                Button {
                    Task { await send(input) }
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title)
                        .foregroundStyle(canSend ? DentIQ.Color.accent : DentIQ.Color.textMuted)
                        .frame(width: DentIQ.Spacing.minTapTarget, height: DentIQ.Spacing.minTapTarget)
                }
                .disabled(!canSend)
                .accessibilityLabel("Senden")
                .sensoryFeedback(.impact(weight: .light), trigger: messages.count)
            }
            .padding(.horizontal, DentIQ.Spacing.m)
            Text("KI-Antworten können Fehler enthalten. Im Zweifel gilt der Expertenkommentar.")
                .font(DentIQ.Font.meta)
                .foregroundStyle(DentIQ.Color.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DentIQ.Spacing.m)
        }
        .padding(.vertical, DentIQ.Spacing.s)
    }

    private var canSend: Bool {
        !isLoading && !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Schickt eine Nachricht (oder im Erklär-Modus mit `nil` die erste Anfrage) an Dr. Lukas.
    private func send(_ text: String?) async {
        if let text {
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }
            messages.append(.init(role: .user, text: trimmed))
            input = ""
        }
        isLoading = true
        errorMessage = nil
        do {
            let reply: String
            switch mode {
            case .ask(let step):
                reply = try await DrLukasService.ask(messages, about: step, in: patientCase)
            case .explain(let step):
                reply = try await DrLukasService.explain(messages, step: step, in: patientCase)
            }
            messages.append(.init(role: .assistant, text: reply))
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

// MARK: - Vorschlags-Chip
private struct SuggestionChipStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DentIQ.Font.secondary)
            .foregroundStyle(DentIQ.Color.textPrimary)
            .padding(.horizontal, DentIQ.Spacing.m)
            .frame(minHeight: DentIQ.Spacing.minTapTarget - DentIQ.Spacing.xs)
            .background(Capsule().fill(DentIQ.Color.surfaceAccent))
            .contentShape(Capsule())
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}

// MARK: - Sprechblase
private struct ChatBubble: View {
    let role: DrLukasService.ChatMessage.Role
    let text: String

    static let avatarSize: CGFloat = 36
    static let avatarInset: CGFloat = avatarSize + DentIQ.Spacing.s

    var body: some View {
        HStack(alignment: .top, spacing: DentIQ.Spacing.s) {
            if role == .assistant {
                Image("dr_lukas")
                    .resizable()
                    .scaledToFill()
                    .frame(width: Self.avatarSize, height: Self.avatarSize)
                    .background(DentIQ.Color.surfaceAccent)
                    .clipShape(Circle())
                    .accessibilityHidden(true)
            } else {
                Spacer(minLength: DentIQ.Spacing.xl)
            }
            Text(text)
                .font(DentIQ.Font.body)
                .foregroundStyle(role == .assistant ? DentIQ.Color.textPrimary : DentIQ.Color.onButtonPrimary)
                .lineSpacing(3)
                .padding(.horizontal, DentIQ.Spacing.m)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: DentIQ.Radius.group, style: .continuous)
                        .fill(role == .assistant ? DentIQ.Color.surface : DentIQ.Color.buttonPrimary)
                )
                .textSelection(.enabled)
            if role == .assistant { Spacer(minLength: DentIQ.Spacing.l) }
        }
        .frame(maxWidth: .infinity, alignment: role == .assistant ? .leading : .trailing)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(role == .assistant ? "Dr. Lukas: \(text)" : "Du: \(text)")
    }
}
