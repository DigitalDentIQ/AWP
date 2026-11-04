# DentIQ ZahnChallenge

**Interaktive Lern-App für Zahnmedizin-Studierende von Digital DentIQ**

Die DentIQ ZahnChallenge ist eine iOS-App, mit der Studierende der Zahnmedizin klinisches Denken an realistischen Patientenfällen trainieren. Sie bearbeiten jeden Fall Schritt für Schritt: von der Anamnese über Befund und Diagnose bis zur Therapie. Dabei erhalten sie sofort Feedback. Interaktive 3D-Modelle machen Befunde und Behandlungsergebnisse greifbar. Der KI-Tutor Dr. Lukas begleitet sie durch jeden Fall, gibt Hinweise, ohne die Lösung vorwegzunehmen, und bewertet Fotos eigener Übungsbehandlungen.

## Funktionen

- **Patientenfälle:** Drei vollständige Fälle aus Notfall/Trauma, Endodontie und Parodontologie. Aufgabentypen: Freitext, Single- und Multiple-Choice, Bildauswahl (z. B. Röntgenbilder), Sortieren, Zuordnen und Foto-Upload.
- **3D-Viewer & AR:** Ausgangsbefund, fehlerhafte und korrekte Versorgung im direkten Vergleich, auf dem iPhone auch in Augmented Reality.
- **KI-Tutor Dr. Lukas:** Hilfe in jedem Schritt, Erklärungen nach falschen Antworten und Feedback zu Fotos von Übungsbehandlungen.
- **Fortschritt & Ranking:** Anonymes Konto mit Nickname, gespeicherter Fortschritt und Bestenliste.
- **Widget:** Homescreen-Widget für den schnellen Einstieg in einen Fall.
- **Design:** Durchgängiges DentIQ-Designsystem mit hellem und dunklem Modus.

**Technologie:** SwiftUI · SceneKit · AR Quick Look · WidgetKit · Supabase · Google Gemini

---

## Zusammenarbeit: Immer zuerst in einem eigenen Branch arbeiten

> **Wichtig:** Auf `main` wird nie direkt gearbeitet. `main` enthält immer den geprüften, lauffähigen Stand der App.

Jede Änderung, ob neue Funktion, Fehlerbehebung oder Textkorrektur, entsteht in einem **eigenen Branch**. Erst nach Überprüfung durch das DentIQ-Team wird sie in `main` übernommen.

### Ablauf

1. **Aktuellen Stand holen:** `git checkout main` und `git pull`
2. **Neuen Branch anlegen:** `git checkout -b feature/kurze-beschreibung`
3. **Entwickeln und committen:** kleine, nachvollziehbare Commits mit klarer Nachricht
4. **Branch hochladen:** `git push -u origin feature/kurze-beschreibung`
5. **Pull Request auf `main` öffnen:** kurz beschreiben, was geändert wurde und warum. Bei Änderungen an der Oberfläche Screenshots anhängen.
6. **Review:** Das DentIQ-Team prüft die Änderung und gibt Feedback. Anpassungen erfolgen im selben Branch.
7. **Übernahme in `main`:** Nach erfolgreicher Prüfung übernimmt das DentIQ-Team die Änderung.

### Branch-Namen

- `feature/` für neue Funktionen, z. B. `feature/fall-4-prothetik`
- `fix/` für Fehlerbehebungen, z. B. `fix/absturz-foto-upload`
- `design/` für Gestaltung, z. B. `design/ranking-dunkelmodus`
- `docs/` für Dokumentation, z. B. `docs/setup-anleitung`

### Vor jedem Pull Request

- Die App baut fehlerfrei in Xcode.
- Die Änderung wurde im Simulator oder auf einem Gerät getestet.
- Es stehen keine Zugangsdaten, Passwörter oder API-Schlüssel im Code.

---

## Einrichtung

Voraussetzung: Mac mit aktueller Xcode-Version (iOS 26.5 SDK).

1. Repository klonen und das Xcode-Projekt öffnen.
2. Zugangsdaten für das Backend erhaltet ihr direkt vom DentIQ-Team, nicht über das Repository.
3. App im Simulator oder auf einem iOS-Gerät starten.

## Kontakt

**Digital DentIQ** · info.digitaldentiq@gmail.com

© 2026 Digital DentIQ. Alle Rechte vorbehalten. Dieses Repository ist vertraulich und nur für autorisierte Projektbeteiligte bestimmt.
