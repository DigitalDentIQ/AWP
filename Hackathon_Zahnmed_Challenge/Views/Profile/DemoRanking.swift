import Foundation

// ┌──────────────────────────────────────────────────────────────────────┐
// │ NUR ZUM VISUALISIEREN UND TESTEN DES RANKINGS                        │
// │                                                                      │
// │ Diese Einträge sind ausgedacht. Sie füllen das Ranking, damit man    │
// │ Podest und Liste ansehen kann, solange noch kaum echte Nutzer:innen  │
// │ im Ranking stehen. Sie werden NICHT an Supabase gesendet.            │
// │                                                                      │
// │ Abschalten: `isEnabled = false` setzen.                              │
// │ Vor einem Release: diese Datei löschen und die Stelle in             │
// │ LeaderboardView.load() entfernen (Suche nach „DemoRanking“).         │
// │ Läuft ohnehin nur in Debug-Builds, nie im App Store.                 │
// └──────────────────────────────────────────────────────────────────────┘
enum DemoRanking {
    #if DEBUG
    static let isEnabled = true
    #else
    static let isEnabled = false
    #endif

    /// Reihenfolge wie gewünscht (04.11.2026); Punkte frei gewählt, absteigend.
    static let entries: [LeaderboardEntry] = [
        LeaderboardEntry(rank: 1, nickname: "AWP Team 1", points: 1480, completedCases: 3),
        LeaderboardEntry(rank: 2, nickname: "Felix",      points: 1320, completedCases: 3),
        LeaderboardEntry(rank: 3, nickname: "nina",       points: 1250, completedCases: 3),
        LeaderboardEntry(rank: 4, nickname: "Eva",        points: 1190, completedCases: 3),
        LeaderboardEntry(rank: 5, nickname: "Simon",      points: 1060, completedCases: 2),
        LeaderboardEntry(rank: 6, nickname: "Gabriela",   points: 940,  completedCases: 2),
        LeaderboardEntry(rank: 7, nickname: "Anna-Lena",  points: 820,  completedCases: 2),
        LeaderboardEntry(rank: 8, nickname: "Maximilian", points: 700,  completedCases: 1),
        LeaderboardEntry(rank: 9, nickname: "Felix",      points: 560,  completedCases: 1),
    ]
}
