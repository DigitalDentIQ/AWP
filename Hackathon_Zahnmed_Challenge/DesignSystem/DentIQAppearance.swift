import UIKit

extension DentIQ {
    /// Globale UIKit-Einstellungen, die SwiftUI nicht direkt anbietet.
    /// Hintergrund und Glas der Leisten bleiben bewusst beim System (Apple HIG: Leisten nicht selbst einfärben).
    enum Appearance {
        static func configure() {
            configureNavigationBar()
        }

        /// Navigationstitel in Manrope und Navy (dunkel: Weiß), mit Dynamic Type.
        private static func configureNavigationBar() {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()

            if let inline = UIFont(name: Font.Name.manropeMedium.rawValue, size: 17) {
                appearance.titleTextAttributes = [
                    .font: UIFontMetrics(forTextStyle: .headline).scaledFont(for: inline),
                    .foregroundColor: Palette.textPrimaryDynamic,
                ]
            }
            if let large = UIFont(name: Font.Name.manropeRegular.rawValue, size: 32) {
                appearance.largeTitleTextAttributes = [
                    .font: UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: large),
                    .foregroundColor: Palette.textPrimaryDynamic,
                ]
            }

            let navigationBar = UINavigationBar.appearance()
            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
    }
}
