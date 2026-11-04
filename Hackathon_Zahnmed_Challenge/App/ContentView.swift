import SwiftUI

// MARK: - ROOT VIEW
/// Systemleiste unten mit drei Bereichen: Start, Ranking, Dr. Lukas.
/// Auf iOS 26 bekommt sie automatisch Liquid Glass.
struct ContentView: View {
    @StateObject private var state = AppState()
    @StateObject private var navState = NavState()
    @StateObject private var backend = BackendService()

    var body: some View {
        TabView(selection: $navState.selectedTab) {
            Tab("Start", systemImage: "house", value: AppTab.home) {
                NavigationStack {
                    HomeView(state: state)
                }
                // Neue ID → Stapel springt zurück auf die Startseite
                .id(navState.homeID)
            }

            Tab("Ranking", systemImage: "trophy", value: AppTab.ranking) {
                LeaderboardView()
            }

            Tab("Dr. Lukas", systemImage: "stethoscope", value: AppTab.drLukas) {
                // Direkt im Chat, ohne Zwischenseite
                DrLukasChatView(mode: .ask(nil), greetingName: backend.profile?.nickname, isEmbedded: true)
            }
            // Hinweis, bis die App-Tour einmal angesehen wurde
            .badge(state.hasSeenTour ? 0 : 1)
        }
        .tint(DentIQ.Color.accent)
        // Sheets an der TabView, damit sie auch aus einem Fall heraus aufgehen
        .sheet(item: $state.activeSheet) { sheet in
            switch sheet {
            case .tour:
                AppTourView()
            }
        }
        .environmentObject(navState)
        .environmentObject(state)
        .environmentObject(backend)
        .task { await backend.start() }
    }
}

// MARK: - HOME
/// Startseite: bisheriges Layout, im DentIQ-Design.
struct HomeView: View {
    @ObservedObject var state: AppState

    /// Such-Overlay offen?
    @State private var isSearching = false
    /// Fall, der nach dem Schließen der Suche geöffnet wird.
    @State private var caseFromSearch: PatientCase?
    @State private var showsCaseFromSearch = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DentIQ.Spacing.m + DentIQ.Spacing.xs) {
                TopBarView()
                SearchBarView { isSearching = true }
                CategoryPillsView(state: state)
                HeroBannerView()
                NavigationLink(destination: ModelOverviewView()) {
                    Modell3DButtonView()
                }
                .buttonStyle(.plain)
                .padding(.horizontal, DentIQ.Spacing.m)
                CasesSectionView(state: state)
                Spacer(minLength: DentIQ.Spacing.l)
            }
        }
        .background(DentIQ.Color.groupedBackground)
        .toolbarVisibility(.hidden, for: .navigationBar)
        // Suche als Overlay über der Startseite; der gewählte Fall öffnet sich danach hier im Stapel
        .sheet(isPresented: $isSearching, onDismiss: {
            if caseFromSearch != nil { showsCaseFromSearch = true }
        }) {
            CaseSearchOverlay { patientCase in
                caseFromSearch = patientCase
                isSearching = false
            }
        }
        .navigationDestination(isPresented: $showsCaseFromSearch) {
            if let caseFromSearch {
                CaseDetailView(patientCase: caseFromSearch)
            }
        }
        .onChange(of: showsCaseFromSearch) { _, isShown in
            if !isShown { caseFromSearch = nil }
        }
    }
}
