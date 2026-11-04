import SwiftUI

/// Layout mit genau zwei Bereichen: oben der Inhalt, unten ein Block (z. B. Buttons).
/// Ist die Seite kürzer als `minHeight` (die sichtbare Höhe), sitzt der untere Block am unteren Rand.
/// Ist sie länger, folgt er mit `minGap` Abstand nach dem Inhalt und alles scrollt mit.
/// Kein Overlay: beide Bereiche sind normaler Seiteninhalt.
struct PinnedBottomLayout: Layout {
    var minHeight: CGFloat
    var minGap: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width
        let heights = subviews.map { $0.sizeThatFits(ProposedViewSize(width: width, height: nil)).height }
        let content = heights.reduce(0, +) + minGap * CGFloat(max(subviews.count - 1, 0))
        let fallbackWidth = subviews.map { $0.sizeThatFits(.unspecified).width }.max() ?? 0
        return CGSize(width: width ?? fallbackWidth, height: max(minHeight, content))
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard let top = subviews.first else { return }
        let width = ProposedViewSize(width: bounds.width, height: nil)
        top.place(at: CGPoint(x: bounds.minX, y: bounds.minY), anchor: .topLeading, proposal: width)

        guard subviews.count > 1, let bottom = subviews.last else { return }
        let bottomHeight = bottom.sizeThatFits(width).height
        bottom.place(at: CGPoint(x: bounds.minX, y: bounds.maxY - bottomHeight), anchor: .topLeading, proposal: width)
    }
}
