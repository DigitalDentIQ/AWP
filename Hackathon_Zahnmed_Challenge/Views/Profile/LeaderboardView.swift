import SwiftUI

// MARK: - LEADERBOARD (Tab „Ranking“)
/// Podest für die ersten drei, darunter die übrigen Plätze. Die eigene Zeile ist hervorgehoben.
struct LeaderboardView: View {
    @EnvironmentObject private var backend: BackendService
    @EnvironmentObject private var appState: AppState
    @State private var entries: [LeaderboardEntry] = []
    @State private var isLoading = true
    @State private var loadFailed = false

    private var ownNickname: String? { backend.profile?.nickname }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DentIQ.Spacing.l) {
                    DentIQScreenHeader(eyebrow: "Bestenliste / Alle Fälle", title: "Ranking")

                    if ownNickname == nil {
                        nicknameHint
                    }

                    content
                }
                .padding(.horizontal, DentIQ.Spacing.margin)
                .padding(.vertical, DentIQ.Spacing.l)
            }
            .background(DentIQ.Color.background)
            .toolbarVisibility(.hidden, for: .navigationBar)
            .task { await load() }
            .refreshable { await load() }
        }
    }

    @ViewBuilder
    private var content: some View {
        if isLoading {
            ProgressView("Lade Ranking…")
                .frame(maxWidth: .infinity)
                .padding(.top, DentIQ.Spacing.xl)
        } else if loadFailed {
            ContentUnavailableView("Ranking nicht verfügbar",
                                   systemImage: "wifi.slash",
                                   description: Text("Bitte prüfe deine Internetverbindung."))
        } else if entries.isEmpty {
            ContentUnavailableView("Noch niemand im Ranking",
                                   systemImage: "trophy",
                                   description: Text("Schließe einen Fall ab und lege einen Nickname fest."))
        } else {
            RankingPodium(entries: entries.prefix(3).map { entry in
                RankingPodium.Entry(
                    rank: entry.rank,
                    name: entry.nickname,
                    points: entry.points,
                    isCurrentUser: entry.nickname == ownNickname
                )
            })

            LazyVStack(spacing: 0) {
                ForEach(entries.dropFirst(3)) { entry in
                    RankingRow(
                        rank: entry.rank,
                        name: entry.nickname,
                        points: entry.points,
                        detail: "\(entry.completedCases) Fälle abgeschlossen",
                        isCurrentUser: entry.nickname == ownNickname
                    )
                }
            }
        }
    }

    private var nicknameHint: some View {
        DentIQCard(style: .surface) {
            Text("Lege einen Nickname fest, um im Ranking zu erscheinen.")
                .font(DentIQ.Font.secondary)
                .foregroundStyle(DentIQ.Color.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
            NavigationLink("Nickname festlegen") {
                ProfileView()
            }
            .buttonStyle(.dentIQSecondary)
        }
    }

    private func load() async {
        // NUR ZUM TESTEN: ausgedachte Einträge statt Server-Daten (siehe DemoRanking.swift)
        if DemoRanking.isEnabled {
            entries = DemoRanking.entries
            loadFailed = false
            isLoading = false
            return
        }
        do {
            entries = try await backend.leaderboard()
            loadFailed = false
        } catch {
            loadFailed = true
        }
        isLoading = false
    }
}
