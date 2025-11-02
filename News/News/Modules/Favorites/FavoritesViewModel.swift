import Foundation

final class FavoritesViewModel: ObservableObject {
    // MARK: Internal variables
    var favoriteTopics: [FavoriteArticle] {
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

// MARK: - Public
extension FavoritesViewModel {
    var hasFavorites: Bool {
        !settingsManager.favoriteTopics.isEmpty
    }

    func removeFavorites() {
        favoriteTopics.removeAll()
    }
}
