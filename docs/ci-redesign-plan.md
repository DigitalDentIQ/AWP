# Ziel: Die ganze ZahnChallenge-App sieht aus wie Digital DentIQ

Branch: `ci-redesign` (von `main`, damit `main` unangetastet bleibt)
CI-Vorgabe: DentIQ-CI-Prompt (Farben, Manrope + Plus Jakarta Sans, eckig, Hairlines, Teal als einziger Akzent)

## Ausgangslage (Bestandsaufnahme)

1. SwiftUI, iOS 26.5, 50 Swift-Dateien, Ordner `App/ Models/ Services/ Views/ DesignSystem/`.
2. `DesignSystem/` enthält nur `Color(hex: String)`, keine Tokens.
3. Ca. 40 verschiedene Hex-Farben direkt in 32 Dateien, Hauptblau `084B83` über 80-mal.
4. Schrift überall `.font(.system(size: 8 bis 72))`, keine Textstile, kein Dynamic Type.
5. Keine eigenen Schriften, kein Logo-Asset, `AccentColor` ungenutzt.
6. Kein Dark Mode.
7. Eigene untere Leiste (`BottomNavView`, `withBottomNav()`), kein `TabView`.
8. Screens: Startseite (Hero, Suche, Kategorie-Pillen, Fallkarten), Fall-Detail, Fall-Ablauf mit 6 Aufgabentypen, Fall abgeschlossen, Dr. Lukas (Panel, Chat, Tour), 3D-Viewer, Profil, Rangliste, Avatar-Auswahl, Widget.
9. Nur 2 VoiceOver-Labels.
10. Kein Build-System auf dem Linux-Server: Bauen und Prüfen passiert bei euch in Xcode.

## Fahrplan

- [x] 1. Branch `ci-redesign` anlegen, Plan ablegen
  - [x] Projekt frisch von GitHub nach `~/Developer/zahnchallenge-anni` geholt, alte Kopien im Papierkorb, `Kopie` bleibt als Sicherung
- [x] 2. Material: Vorlage geprüft (Farben + Schriften stimmen mit CI überein), Entscheidungen getroffen
- [x] 3. Design-System: `DentIQColors`, `DentIQFonts`, `DentIQSpacing`, Schriften registriert, Debug-Check, `DentIQStyleGuide` als Vorschau
- [x] 4. Basiskomponenten in `DesignSystem/Components/` (Eyebrow, Linien, Header, Karte, Buttons, KPI, Tabelle, Fortschritt, Status, Kapitelfläche, Eingabefeld) + `DentIQComponentsGallery` als Vorschau
- [x] 5. Globale Stellen: System-`TabView` (Start · Ranking · Dr. Lukas), Teal-Tint, Navigationstitel in Manrope, Fokusmodus im Fall-Ablauf, Dr.-Lukas-Bereich und Ranking mit Podest neu
- [x] 6. Screen: Startseite (Fallkarten gleich hoch; Layout unverändert, nur CI: Navy-Hero statt Verlauf, Mint-Flächen auf Fallkarten, Teal-Sterne, Manrope/Jakarta, weiche Karten auf getöntem Grund; Kopf nach Skizze vom 04.11.: „DentIQ“-Schriftzug oben links als Logo-Platzhalter, Profil oben rechts, Begrüßung darunter; Suchfeld als Kapsel öffnet die Suche als Overlay (sucht in Titel, Fachgebiet, Patient, Stichworten); Hero als Navy-Karte mit Dr. Lukas und „Jetzt lernen & Punkte sammeln“. Skizzen geben nur das Layout vor, Formen kommen aus dem Designsystem)
- [x] 7. Screen: Fall-Detail (Layout unverändert: Bild mit Navy-Etiketten, Mint statt Verlauf ohne Foto, Patientenkarte mit Teal-Zitatlinie, Stichwort-Zeile entfernt, Fallverlauf als Karte mit zwei Spalten ohne Scrollen, Abgeschlossen-Box in Mint, Primär-Button)
- [x] 8. Screens: Fall-Ablauf (6 Aufgabentypen) und Fall abgeschlossen (Layout unverändert; richtig = Teal + Häkchen, falsch = Rot + Kreuz, richtig aber nicht angekreuzt = Rot + Ausrufezeichen; „Expertenkommentar“ statt „Dr. Zahnix kommentiert“; Haptik bei Abgabe; kompaktere Schriften; Dr.-Lukas-Feld im Stil des Expertenkommentars; Frage des Schritts im Chat vorbefüllt; nur noch ein „Schritt x von y“; Gesamtpunkte oben; Weiter-Button ohne Hereinfliegen; Kategorie-Kapsel über der Frage entfernt; Tipp-Feld heißt „Expertenkommentar“; Upload Fall 1 bis 6 Fotos; Aufteilung nach Skizze: Fortschritt, Frage und Antworten oben; Dr. Lukas und Button als normaler Seiteninhalt unten (kein Overlay, Abstand wird berechnet), bei langem Inhalt dahinter; Bestätigen-Button immer sichtbar, ausgegraut bis etwas ausgewählt ist; Sortieren per Ziehen (System-Griff in der Karte), richtig Teal / falsch Rot; Fotos bleiben im Feld; KI-Auswertung mittig; kurze Antworten mittig im Raster (≤ 8 Zeichen 3 Spalten, ≤ 16 Zeichen 2 Spalten, bei sehr großer Schrift 1 Spalte); Bildauswahl zeigt Röntgenbilder vollständig)
- [x] 9. Screens: Dr. Lukas (Chat im neuen Design und direkt im Tab, Feld im Fall-Schritt, App-Tour im neuen Design; KI-Modell nicht angeschlossen → KI-Themen übersprungen; Tour-Logik kommt mit dem Login)
- [x] 10. Screens: 3D-Viewer (Layout unverändert; Modellfarben nach Bedeutung: Befund Navy, fehlerhaft Rot, korrekt Teal; Lerntipp in Mint mit Teal-Kante statt Gelb; AR-Button im Primärstil)
- [x] 11. Screen: Profil als eigene Seite (Profil-Symbol oben rechts und „Nickname festlegen“ im Ranking öffnen sie): Avatar, Punkte/Fälle/Rang, Nickname + Ranking-Sichtbarkeit, Fortschritt je Fall mit bestem Ergebnis, Zurücksetzen, Verbindung
- [-] 12. Widget – entfällt (Entscheidung 04.11.2026)
- [-] 13. Logo, Launch Screen, App-Icon – entfällt vorerst (Entscheidung 04.11.2026); „DentIQ“-Schriftzug auf der Startseite bleibt Platzhalter
- [x] 14. Abnahme-Check und Abschlussbericht (`docs/ci-redesign-bericht.md`); alte Farbhilfe und ungenutzte Verlaufsfarben entfernt. Pull Request nach `main`: auf Wunsch

## Offene Punkte (Liste)

- [ ] „Warum war das falsch? Dr. Lukas erklärt“ funktioniert nicht. Vermutete Ursache: Gemini-2.5-Denk-Tokens verbrauchen maxOutputTokens (600) → leere Antwort. Fix in `supabase/functions/dr-lukas/index.ts` (Denken aus bei Flash, Limit 1024). **Muss im Supabase-Dashboard neu deployt werden, sobald das KI-Modell angeschlossen ist (GEMINI_API_KEY als Secret).**
- [x] Fehlermeldung „Dr. Lukas ist gerade nicht erreichbar“ im Chat mittig.
- [ ] App-Tour-Logik zusammen mit dem Login überarbeiten.
- [x] Profil als eigene Seite (Schritt 11).

- [ ] **Vor Release:** Test-Ranking entfernen (`Views/Profile/DemoRanking.swift` + Stelle in `LeaderboardView.load()`). Läuft nur in Debug-Builds.

## Entscheidungen (04.11.2026)

| Thema | Entscheidung | CI? |
|---|---|---|
| Dark Mode | Abgeleitet: Grund minimal blaugrau `#15273A`, Flächen `#1F3447`, Karten helleres Teal `#1E4F57`, Teal aufgehellt `#2BB3AD` | abgeleitet, nicht CI |
| Ecken | Weich statt eckig: `.continuous`-Radien 28/24/20/8/6, Buttons und Eingabefelder als Kapsel, Marker rund | Abweichung (CI: eckig), gewünscht für Apple-Feeling |
| Ranking | Podest (2 · 1 · 3) auf Navy-Fläche mit Monogramm-Avataren, darunter Liste; eigene Zeile auf Soft Mint. Ersetzt die CI-Tabelle | Abweichung (CI: Tabelle mit Navy-Kopf), gewünscht |
| Grundsatz Screens | Layout und Aufbau der App bleiben, nur die CI wird draufgelegt (Entscheidung 04.11.2026 nach Rückmeldung zur Startseite) | |
| Eyebrow-Zeilen | Nur mit echter Information; auf der Startseite entfallen (Skizze) | |
| Seitengrund | Gruppierter Stil wie bei Apple: getönter Grund (`groupedBackground`), weiße Karten (`groupedSurface`) | |
| Expertenkommentar | Überschrift „Expertenkommentar“ statt „Dr. Zahnix kommentiert“, damit nicht zwei Doktoren auftauchen | |
| Zusammenarbeit | Bei Unsicherheit zu Layout vorher fragen | |
| Status-Tags | Entfernt. Richtig/falsch wird direkt an der Antwort gezeigt (Rahmen + Symbol) | |
| Kontrast erhöhen | Eigene Varianten für Teal, Hairline und Hilfstext (Apple HIG) | Ergänzung |
| Tiefe | Hell: zwei sehr weiche Schatten · Dunkel: feine helle Kante statt Schatten | Ergänzung |
| Fehlerfarbe | Klares Rot `#C62828` (5,6:1 auf Weiß), dunkel `#FF6B6B` (vorher Ziegelrot `#A8433A`, war zu gedämpft) | nicht CI |
| Tab-Leiste | System-`TabView` mit Liquid Glass, Teal als Aktivfarbe. Tabs: Start · Ranking · Dr. Lukas, kein Such-Tab (Tab Dr. Lukas öffnet direkt den Chat, App-Tour über ? oben rechts) | begründete Abweichung (CI verbietet Glas) |
| Fall-Ablauf | Fokusmodus: Tab-Leiste ausgeblendet | |
| Logo | kommt zum Schluss; bisher nur PNG 183×52 (Vorlage enthält dieselbe PNG) | |

## Abweichungen / Hinweise

- `ProgressSteps`: weiße 11-pt-Nummern auf Teal haben nur 3,7:1. So von der CI vorgegeben ("Nummern weiß"); bei „Kontrast erhöhen“ wird Teal dunkler (6,1:1); VoiceOver liest „Schritt x von y“.
- Buttons: Druck-Feedback (leichtes Einsinken + Haptik), bei „Bewegung reduzieren“ nur Abdunkeln.
- Chart-Style: In der App gibt es derzeit keine Diagramme. Farben dafür liegen in `DentIQ.Color.chartSeries`.

## Prüfergebnisse

- Vorlage `Digital_DentIQ_Slidemaster.pptx`: alle 10 CI-Farben exakt so verwendet; Schriften Manrope + Plus Jakarta Sans.
- Logo-Pixel (PNG, ungenau wegen Kantenglättung): Navy ≈ `#10263B` (CI `#102238`), Teal ≈ `#389B99` (CI `#189490`). Tokens unverändert.
- Kontrast: `textMuted #8BA0AC` hat nur 2,7:1 auf Weiß → nur für Meta/Footer, nie für wichtige Inhalte. Teal 3,7:1 → nur große Schrift, Icons, Linien.
- Schriften: Plus Jakarta Sans statisch aus dem offiziellen Repo; Manrope gibt es nur als Variable Font, statische Schnitte Light/Regular/Medium daraus mit fontTools erzeugt. Lizenz OFL liegt bei.

Nach jedem Schritt: ich pushe, ihr zieht den Branch in Xcode, baut und schaut drauf. Erst dann kommt der nächste Schritt.

## Notizen

- Schritt 1: Alles passiert auf `ci-redesign`. `main` bleibt, wie es ist. Wenn etwas schiefgeht, ist `main` der sichere Stand.
- Schritt 1b: Im Terminal immer erst mit `cd` in den Projektordner wechseln, sonst findet Git nichts. Vor dem Löschen prüfen, ob ungesicherte Arbeit im Ordner liegt.
- Schritt 3: Views nutzen nur noch Namen nach Aufgabe (`DentIQ.Color.textPrimary`), nie Hex-Werte. So reicht eine Änderung an einer Stelle für die ganze App, und Dark Mode kommt automatisch mit.
- Schritt 4 (Überarbeitung): Ecken immer `.continuous` und konzentrisch denken, Farben brauchen Varianten für hell, dunkel und „Kontrast erhöhen“.
