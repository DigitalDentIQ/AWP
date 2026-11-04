import SwiftUI

// MARK: - STEP: FOTO-UPLOAD
struct UploadStepView: View {
    let step: CaseStep
    let task: UploadTask
    @ObservedObject var session: CaseSession
    @State private var isEvaluating = false
    @State private var images: [UIImage] = []
    @State private var showPicker = false

    private var usesAI: Bool { task.aiPrompt != nil }

    private var submitTitle: String {
        if isEvaluating { return "Dr. Lukas wertet aus…" }
        return usesAI ? "Zur Kontrolle an KI abgeben" : "Abgeben"
    }

    var body: some View {
        StepScaffold(step: step, session: session, typeLabel: "PRAXISAUFGABE",
                     isSubmitted: false, score: 0,
                     submitTitle: submitTitle,
                     canSubmit: images.count >= task.minFiles && !isEvaluating,
                     isBusy: isEvaluating,
                     onSubmit: submit) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: DentIQ.Spacing.m - 2) {
                ForEach(0..<task.maxFiles, id: \.self) { idx in
                    PhotoSlotView(
                        image: idx < images.count ? images[idx] : nil,
                        onAdd: { showPicker = true },
                        onRemove: { guard idx < images.count else { return }; images.remove(at: idx) }
                    )
                    .aspectRatio(1, contentMode: .fit)
                }
            }
            .padding(.horizontal, DentIQ.Spacing.m)

            Text(images.count < task.minFiles
                 ? "Bitte mindestens \(task.minFiles) Bild\(task.minFiles == 1 ? "" : "er") hochladen"
                 : "\(images.count) / \(task.maxFiles) Bilder hochgeladen")
                .font(DentIQ.Font.secondary)
                .foregroundStyle(DentIQ.Color.textSecondary)
        }
        .sheet(isPresented: $showPicker) { ImagePicker(images: $images, maxCount: task.maxFiles) }
    }

    private func submit() {
        guard let prompt = task.aiPrompt,
              let imageData = images.first?.jpegData(compressionQuality: 0.5) else {
            session.advance()
            return
        }
        isEvaluating = true
        Task {
            do {
                session.aiFeedback = try await DrLukasService.evaluatePhoto(imageData, prompt: prompt)
            } catch {
                // Ehrlich bleiben: kein erfundenes Feedback, wenn die KI nicht erreichbar ist
                session.aiFeedback = "Die KI-Auswertung ist gerade nicht verfügbar (\(error.localizedDescription)). Deine Bilder wurden nicht bewertet."
            }
            isEvaluating = false
            session.advance()
        }
    }
}

private struct PhotoSlotView: View {
    let image: UIImage?
    let onAdd: () -> Void
    let onRemove: () -> Void

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: DentIQ.Radius.tile, style: .continuous)
    }

    var body: some View {
        if let img = image {
            ZStack(alignment: .topTrailing) {
                // Quadratisches Feld, das Foto füllt es und wird an seinen Rändern abgeschnitten
                Color.clear
                    .aspectRatio(1, contentMode: .fit)
                    .overlay {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                    }
                    .clipShape(shape)
                    .overlay(shape.strokeBorder(DentIQ.Color.hairline, lineWidth: DentIQ.Spacing.hairline))
                    .accessibilityLabel("Hochgeladenes Foto")
                Button(action: onRemove) {
                    Image(systemName: "xmark")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(DentIQ.Color.onInverse)
                        .frame(width: 28, height: 28)
                        .background(Circle().fill(DentIQ.Color.surfaceInverse.opacity(0.85)))
                        .frame(width: DentIQ.Spacing.minTapTarget, height: DentIQ.Spacing.minTapTarget)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Foto entfernen")
            }
        } else {
            Button(action: onAdd) {
                VStack(spacing: DentIQ.Spacing.s) {
                    Image(systemName: "plus")
                        .font(.title.weight(.light))
                        .foregroundStyle(DentIQ.Color.accent)
                    Text("Foto hinzufügen")
                        .font(DentIQ.Font.secondary)
                        .foregroundStyle(DentIQ.Color.textPrimary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(shape.fill(DentIQ.Color.groupedSurface))
                .overlay(
                    shape.strokeBorder(DentIQ.Color.hairline, style: StrokeStyle(lineWidth: 1.5, dash: [6]))
                )
            }
            .buttonStyle(.plain)
        }
    }
}
