import SwiftUI
import Combine

// MARK: - TABS
enum AppTab: Hashable {
    case home, ranking, drLukas
}

// MARK: - NAVIGATION STATE
class NavState: ObservableObject {
    @Published var selectedTab: AppTab = .home
    /// Neue ID setzt den Navigationsstapel der Startseite zurück.
    @Published var homeID = UUID()

    /// Springt zur Startseite und schließt alle geöffneten Fall-Ansichten.
    func goHome() {
        selectedTab = .home
        homeID = UUID()
    }
}
