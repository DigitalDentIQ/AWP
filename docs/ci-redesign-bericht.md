# Abschlussbericht: DentIQ-Redesign der ZahnChallenge-App

Branch `ci-redesign`, Stand 04.11.2026. Grundlage: CI-Vorgabe „Digital DentIQ“ (Präsentationsvorlage) und Apple Human Interface Guidelines. Fahrplan und Einzelentscheidungen: [`ci-redesign-plan.md`](ci-redesign-plan.md).

## Kurzfassung

Die App nutzt jetzt durchgehend das DentIQ-Designsystem: Farben, Schriften, Abstände und Bausteine kommen aus `DesignSystem/`, in den Bildschirmen stehen keine festen Farbcodes oder Schriftgrößen mehr. Layout und Aufbau der Bildschirme sind weitgehend geblieben, nur die CI liegt darauf. Ausnahmen sind dort umgesetzt, wo ihr es so wolltet (Tab-Leiste, Ranking-Podest, Profilseite, Aufteilung der Fall-Schritte).

## Was neu ist

| Bereich | Inhalt |
|---|---|
| Designsystem | `DentIQColors` (Farben nach Aufgabe, hell/dunkel/„Kontrast erhöhen“), `DentIQFonts` (Manrope + Plus Jakarta Sans mit Dynamic Type, Debug-Check beim Start), `DentIQSpacing` (Abstände, Radien, weiche Erhöhung), `DentIQAppearance` (Navigationstitel), Vorschauen `DentIQStyleGuide` und `DentIQComponentsGallery` |
| Bausteine | Buttons (Primär/Sekundär/Link mit Druckzustand und Haptik), Karte, Eyebrow, Linien, Kennzahl, Fortschritt, Ranking-Podest und -Zeile, Kapitelfläche, Eingaberahmen, `PinnedBottomLayout` |
| Schriften | 6 statische TTFs in `Resources/Fonts`, Lizenz OFL liegt bei, Registrierung über `UIAppFonts` |
| Navigation | System-Tab-Leiste Start · Ranking · Dr. Lukas (Liquid Glass), Fokusmodus im Fall-Ablauf |
| Startseite | Layout nach Skizze, DentIQ-Schriftzug, Profil oben rechts, Suche als Overlay, gleich hohe Fallkarten |
| Fall-Detail | Navy-Etiketten, Mint statt Verlauf, Fallverlauf in zwei Spalten |
| Fall-Ablauf | Fortschritt mit Gesamtpunkten, Aufgabe oben, Dr. Lukas und Button unten; richtig Teal, falsch/vergessen Rot; kurze Antworten im Raster; Sortieren per Ziehen; Röntgenbilder vollständig |
| Dr. Lukas | Tab öffnet direkt den Chat, Frage des Schritts vorbefüllt, App-Tour im neuen Design |
| Ranking | Podest + Liste, eigene Zeile hervorgehoben |
| Profil | Eigene Seite: Avatar, Punkte/Fälle/Rang, Nickname, Fortschritt je Fall, Zurücksetzen |
| 3D-Modelle | Farben nach Bedeutung (Befund Navy, fehlerhaft Rot, korrekt Teal) |

Entfernt: eigene untere Leiste, Avatar-Fenster, Profil-Fenster, alte Farbhilfe `Color(hex:)`, ungenutzte Verlaufsfarben im Fallmodell.

## Abweichungen von der CI (mit Begründung)

| Abweichung | Begründung |
|---|---|
| Weiche Ecken (`.continuous`, 6–28 pt), Buttons als Kapsel | CI verlangt eckig (max. 2 pt). Ihr wolltet ein ruhigeres, hochwertigeres Apple-Gefühl. |
| Liquid Glass in der Tab-Leiste | CI verbietet Glas. Systemleiste von iOS 26, nur dort eingesetzt (Apple: Glas für Navigation, nicht für Inhalte). |
| Dark Mode abgeleitet | CI kennt nur hell. Grund `#15273A`, Flächen `#1F3447`, Karten `#1E4F57`, Teal `#2BB3AD`. |
| Fehlerfarbe Rot `#C62828` (dunkel `#FF6B6B`) | CI hat keine Fehlerfarbe. Nach Rückmeldung klares Rot statt gedämpftem Ziegelrot. |
| Ranking als Podest statt Tabelle mit Navy-Kopf | Euer Wunsch nach Vorlage. |
| Eyebrow-Zeilen nur mit echter Information | CI sieht sie auf jedem Screen vor; ohne Inhalt wirkten sie überflüssig. |
| Layout der Bildschirme beibehalten | CI ordnet jedem Bereich ein Folienmuster zu. Ihr wolltet den bestehenden Aufbau behalten. |
| Grauer Untergrund mit weißen Karten (`groupedBackground`) | CI: Weiß als Standardgrund. Gruppierter Stil wie Apples Einstellungen, damit Karten sich abheben. |
| Varianten für „Kontrast erhöhen“ | Ergänzung nach Apple HIG; Teal (3,7:1) und Hilfstext (2,7:1) unterschreiten sonst die Kontrastgrenze. |
| Bild-Vergrößerung auf Schwarz | Wie Apples Fotos-App, für Röntgenbilder am besten lesbar. |
| Feste Größen bei drei großen SF-Symbolen | CI erlaubt `Font.system` für SF Symbols. |

## Abnahme-Checkliste (aus der CI-Vorgabe)

| Punkt | Stand |
|---|---|
| Projekt baut, Previews laufen | Baut bei euch in Xcode (hier kein Build möglich). Previews: StyleGuide und Gallery geprüft. |
| Keine festen Farben/Fonts außerhalb `DesignSystem/` | Erfüllt in der App. Ausnahmen: SF-Symbol-Größen, Schwarz in der Bild-Vergrößerung. Widget nicht umgestellt (Schritt gestrichen). |
| Beide Schriften laden | Erfüllt, Konsole meldet „DentIQ-Schriften geladen“. |
| 10 CI-Farben exakt | Erfüllt, siehe `DentIQ.Palette`. |
| Eyebrow + Manrope-Titel, linksbündig, Hairlines | Teilweise, bewusst: Layout der Screens beibehalten, Eyebrows nur mit Information. |
| Teal nur als Akzent, Kontrast | Erfüllt; kleine Teal-Schrift nur bei Eyebrows (CI-Ausnahme) und Ziffern auf Teal-Markern. |
| Dynamic Type bis „Extra Large“ | Schriften wachsen mit. Noch nicht systematisch auf Gerät geprüft (siehe offene Punkte). |
| Dark Mode | Abgeleitet umgesetzt und dokumentiert. |
| Logo, Launch Screen, App-Icon | Entfällt vorerst (Entscheidung 04.11.2026), „DentIQ“-Schriftzug als Platzhalter. |
| Liste der Abweichungen | Siehe oben. |

## Offene Punkte

1. **KI-Modell anschließen:** Gemini-Key als Supabase-Secret `GEMINI_API_KEY`, danach `supabase/functions/dr-lukas/index.ts` im Dashboard neu deployen. Der Fix gegen leere Antworten („Warum war das falsch?“) ist im Code.
2. **Test-Ranking entfernen** vor einem Release: `Views/Profile/DemoRanking.swift` und die markierte Stelle in `LeaderboardView.load()`. Läuft nur in Debug-Builds.
3. **App-Tour-Logik** mit dem Login überarbeiten.
4. **Dynamic Type** auf Gerät durchtesten (Einstellungen → Anzeige & Helligkeit → Textgröße). Feste Höhen gibt es bei Hero (160 pt), Fallkarten (200 pt breit) und Sortierzeilen (60 pt, wachsen mit).
5. **Widget** und **Logo/App-Icon** sind noch im alten Stand.
6. Fall-JSON enthält noch die alten Farbfelder (`gradientStart`, `starColor`, Badge-Farben). Sie werden nicht mehr genutzt und können beim nächsten Daten-Update raus.
