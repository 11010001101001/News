import Foundation

final class FavoritesViewModel: ObservableObject {
    // MARK: Internal variables
    var favorites: [FavoriteArticle] {
        get { settingsManager.favoriteTopics }
        set { settingsManager.save(favorites: newValue) }
    }

    // MARK: Private variables
    private let settingsManager: SettingsManagerProtocol

    // MARK: Init
    init(
        settingsManager: SettingsManagerProtocol
    ) {
        self.settingsManager = settingsManager
    }
}

// MARK: - Private
private extension FavoritesViewModel {
    
}
