import SwiftUI
import QuickLook
import ARKit

// ─────────────────────────────────────────────
// MARK: - DETAIL-ANSICHT
// ─────────────────────────────────────────────

struct ModelDetailView: View {
    let modell: ZahnModell
    @State private var arPreviewURL: URL?
    @State private var modelLoaded = false
    @State private var modelError = false
    @State private var viewer = SceneViewHandle()

    var usdzURL: URL? {
        Bundle.main.url(forResource: modell.dateiname, withExtension: "usdz")
    }

    private var tileShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.tile, style: .continuous)
    }

    var body: some View {
        VStack(spacing: 0) {

            // 3D Viewer
            ZStack {
                DentIQ.Color.surface

                if let url = usdzURL {
                    SceneKitView(url: url, handle: viewer, onLoaded: {
                        modelLoaded = true
                    }, onError: {
                        modelError = true
                    })
                    if !modelLoaded && !modelError {
                        VStack(spacing: DentIQ.Spacing.s + 2) {
                            ProgressView()
                                .scaleEffect(1.3)
                            Text("Modell wird geladen…")
                                .font(DentIQ.Font.secondary)
                                .foregroundStyle(DentIQ.Color.textSecondary)
                        }
                    }
                    if modelLoaded {
                        zoomButtons
                    }
                } else {
                    // Datei nicht gefunden
                    VStack(spacing: DentIQ.Spacing.m - DentIQ.Spacing.xs) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundStyle(DentIQ.Color.error)
                        Text("Modell nicht gefunden")
                            .font(DentIQ.Font.secondaryMedium)
                            .foregroundStyle(DentIQ.Color.textPrimary)
                        Text("\(modell.dateiname).usdz")
                            .font(DentIQ.Font.meta)
                            .foregroundStyle(DentIQ.Color.textSecondary)
                    }
                }
            }
            .frame(height: 340)

            // Steuer-Hinweise
            HStack(spacing: DentIQ.Spacing.m) {
                Label("Drehen", systemImage: "hand.draw")
                Label("Zoomen: zwei Finger / + −", systemImage: "arrow.up.left.and.arrow.down.right")
                Label("Doppeltippen: zurück", systemImage: "arrow.counterclockwise")
            }
            .font(DentIQ.Font.meta)
            .foregroundStyle(DentIQ.Color.textSecondary)
            .labelStyle(HintLabelStyle())
            .padding(.vertical, DentIQ.Spacing.s + 2)
            .frame(maxWidth: .infinity)
            .background(DentIQ.Color.surfaceAccent)

            // Info-Bereich
            ScrollView {
                VStack(alignment: .leading, spacing: DentIQ.Spacing.m) {

                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: DentIQ.Spacing.xs) {
                            Text(modell.name)
                                .font(DentIQ.Font.heading)
                                .foregroundStyle(DentIQ.Color.textPrimary)
                                .accessibilityAddTraits(.isHeader)
                            Text("Fall 1 · Volksfest-Unfall (Frontzahntrauma)")
                                .font(DentIQ.Font.secondary)
                                .foregroundStyle(DentIQ.Color.textSecondary)
                        }
                        Spacer()
                        Image(systemName: modell.icon)
                            .font(.title)
                            .foregroundStyle(modell.art.tint)
                            .accessibilityHidden(true)
                    }

                    VStack(alignment: .leading, spacing: DentIQ.Spacing.s - 2) {
                        Text("Was du hier siehst")
                            .font(DentIQ.Font.secondaryMedium)
                            .foregroundStyle(DentIQ.Color.textPrimary)
                        Text(modell.lernhinweis)
                            .font(DentIQ.Font.secondary)
                            .foregroundStyle(DentIQ.Color.textPrimary)
                            .lineSpacing(5)
                    }
                    .padding(DentIQ.Spacing.m - 2)
                    .padding(.leading, DentIQ.Spacing.xs)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(tileShape.fill(modell.art.tint.opacity(0.08)))
                    .overlay(alignment: .leading) {
                        Rectangle().fill(modell.art.tint).frame(width: 3)
                    }
                    .clipShape(tileShape)

                    // AR-Button – nur auf Geräten mit AR (im Simulator funktioniert AR Quick Look nicht)
                    if let url = usdzURL, supportsAR {
                        Button(action: { arPreviewURL = url }) {
                            Label("In AR ansehen", systemImage: "arkit")
                        }
                        .buttonStyle(.dentIQPrimary)

                        Text("Das Modell erscheint in Originalgröße (ca. 7–8 cm) auf einer Tischfläche. Mit zwei Fingern kannst du es vergrößern und drehen.")
                            .font(DentIQ.Font.meta)
                            .foregroundStyle(DentIQ.Color.textSecondary)
                    } else if usdzURL != nil {
                        Label("AR gibt es nur auf einem echten iPhone oder iPad. Im Simulator kannst du das Modell oben drehen und zoomen.", systemImage: "info.circle")
                            .font(DentIQ.Font.meta)
                            .foregroundStyle(DentIQ.Color.textSecondary)
                    }
                }
                .padding(DentIQ.Spacing.m)
            }
        }
        .background(DentIQ.Color.groupedBackground)
        .navigationTitle(modell.name)
        .navigationBarTitleDisplayMode(.inline)
        // Apple AR Quick Look: auf dem iPhone mit Umschalter "Objekt" / "AR"
        .quickLookPreview($arPreviewURL)
    }

    private var supportsAR: Bool { ARWorldTrackingConfiguration.isSupported }

    private var zoomButtons: some View {
        VStack(spacing: 0) {
            Button { viewer.zoom(by: 0.7) } label: {
                Image(systemName: "plus").frame(width: 44, height: 44)
            }
            .accessibilityLabel("Vergrößern")
            HairlineDivider().frame(width: 28)
            Button { viewer.zoom(by: 1.4) } label: {
                Image(systemName: "minus").frame(width: 44, height: 44)
            }
            .accessibilityLabel("Verkleinern")
        }
        .font(.body.weight(.semibold))
        .foregroundStyle(DentIQ.Color.textPrimary)
        .background(
            RoundedRectangle(cornerRadius: DentIQ.Radius.tile, style: .continuous)
                .fill(DentIQ.Color.groupedSurface.opacity(0.95))
        )
        .dentIQElevation(in: RoundedRectangle(cornerRadius: DentIQ.Radius.tile, style: .continuous))
        .padding(DentIQ.Spacing.m - DentIQ.Spacing.xs)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Zoom")
    }
}

/// Hinweis-Label mit Teal-Symbol und kleinem Abstand.
private struct HintLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: DentIQ.Spacing.xs) {
            configuration.icon.foregroundStyle(DentIQ.Color.accent)
            configuration.title
        }
    }
}
