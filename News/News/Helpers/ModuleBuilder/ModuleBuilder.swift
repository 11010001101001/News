import Foundation
import SwiftUI

struct ModuleBuilder {
    static let shared = ModuleBuilder()

    @ViewBuilder
    func build(_ module: Module) -> some View {
        switch module {
        case .main:
            MainView()
        case let .details(article):
            DetailsView(article: article)
        case .settings:
            SettingsView()
        case .favorites:
            FavoritesView()
        }
    }
}
