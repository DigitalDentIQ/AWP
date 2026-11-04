import SwiftUI

// MARK: - SUCHE (Overlay)
/// Suche über alle Fälle als Overlay über der Startseite.
/// Sucht in Titel, Fachgebiet, Patient und Stichworten; ohne Eingabe stehen alle Fälle da.
struct CaseSearchOverlay: View {
    /// Wird mit dem gewählten Fall aufgerufen; die Startseite schließt dann das Overlay und öffnet ihn.
    let onSelect: (PatientCase) -> Void

    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    @FocusState private var fieldFocused: Bool

    private var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var results: [PatientCase] {
        guard !trimmedQuery.isEmpty else { return appState.cases }
        return appState.cases.filter { patientCase in
            let fields = [patientCase.title, patientCase.category, patientCase.patient.name]
                + patientCase.tags.map(\.label)
            return fields.contains { $0.localizedCaseInsensitiveContains(trimmedQuery) }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            searchHeader
            Group {
                if results.isEmpty {
                    ContentUnavailableView.search(text: trimmedQuery)
                        .frame(maxHeight: .infinity)
                } else {
                    resultList
                }
            }
        }
        .background(DentIQ.Color.groupedBackground)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .onAppear { fieldFocused = true }
    }

    private var searchHeader: some View {
        HStack(spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs) {
            HStack(spacing: DentIQ.Spacing.s) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(DentIQ.Color.textSecondary)
                    .accessibilityHidden(true)
                TextField("Fall, Fachgebiet oder Patient", text: $query)
                    .font(DentIQ.Font.secondary)
                    .foregroundStyle(DentIQ.Color.textPrimary)
                    .focused($fieldFocused)
                    .submitLabel(.search)
                    .autocorrectionDisabled()
                if !query.isEmpty {
                    Button {
                        query = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(DentIQ.Color.textMuted)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Suche löschen")
                }
            }
            .padding(.horizontal, DentIQ.Spacing.m)
            .frame(height: DentIQ.Spacing.minTapTarget)
            .background(Capsule().fill(DentIQ.Color.groupedSurface))
            .overlay(
                Capsule().strokeBorder(
                    fieldFocused ? DentIQ.Color.accent : DentIQ.Color.hairline,
                    lineWidth: DentIQ.Spacing.hairline
                )
            )

            Button("Abbrechen") { dismiss() }
                .buttonStyle(.dentIQLink)
        }
        .padding(.horizontal, DentIQ.Spacing.m)
        .padding(.top, DentIQ.Spacing.l)
        .padding(.bottom, DentIQ.Spacing.s)
    }

    private var resultList: some View {
        List {
            Section {
                ForEach(results) { patientCase in
                    Button {
                        onSelect(patientCase)
                    } label: {
                        SearchResultRow(
                            patientCase: patientCase,
                            isCompleted: appState.isCompleted(patientCase)
                        )
                    }
                    .listRowBackground(DentIQ.Color.groupedSurface)
                }
            } header: {
                Text(trimmedQuery.isEmpty ? "Alle Fälle" : "Ergebnisse")
                    .font(DentIQ.Font.eyebrow)
                    .tracking(DentIQ.Font.eyebrowTracking)
                    .foregroundStyle(DentIQ.Color.textSecondary)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .scrollDismissesKeyboard(.interactively)
    }
}

// MARK: - Ergebniszeile
private struct SearchResultRow: View {
    let patientCase: PatientCase
    let isCompleted: Bool

    var body: some View {
        HStack(spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs) {
            Image(systemName: patientCase.sfSymbol)
                .foregroundStyle(DentIQ.Color.accent)
                .frame(width: DentIQ.Spacing.minTapTarget, height: DentIQ.Spacing.minTapTarget)
                .background(
                    RoundedRectangle(cornerRadius: DentIQ.Radius.tile, style: .continuous)
                        .fill(DentIQ.Color.surfaceAccent)
                )
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(patientCase.category.uppercased())
                    .font(DentIQ.Font.eyebrow)
                    .tracking(DentIQ.Font.eyebrowTracking)
                    .foregroundStyle(DentIQ.Color.textSecondary)
                Text(patientCase.title)
                    .font(DentIQ.Font.subheading)
                    .foregroundStyle(DentIQ.Color.textPrimary)
                Text(isCompleted ? "Abgeschlossen" : "\(patientCase.difficultyLabel) · \(patientCase.totalSteps) Schritte")
                    .font(DentIQ.Font.meta)
                    .foregroundStyle(isCompleted ? DentIQ.Color.accent : DentIQ.Color.textSecondary)
            }

            Spacer(minLength: DentIQ.Spacing.s)

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(DentIQ.Color.textMuted)
                .accessibilityHidden(true)
        }
        .padding(.vertical, DentIQ.Spacing.xs)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }
}
