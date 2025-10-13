import Foundation
import Combine
import SwiftUI

final class DetailsViewModel: ObservableObject {
    // MARK: Internal variables
    @Published var imageCacheData: (image: AnyObject, key: AnyObject)?
    @Published var feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle?
    @Published var feedBackType: UINotificationFeedbackGenerator.FeedbackType?

    var loader: String {
        get { settingsManager.loader }
        set { settingsManager.save(loader: newValue) }
    }

    var watchedTopics: [String] {
        get { settingsManager.watchedTopics }
        set { settingsManager.save(watchedTopics: newValue) }
    }

    var favoriteTopics: [FavoriteArticle] {
        get { settingsManager.favoriteTopics }
        set { settingsManager.save(favorites: newValue) }
    }

    var loaderShadowColor: Color {
        settingsManager.loaderShadowColor
    }

    // MARK: Private variables
    private let cacheManager: CacheManagerProtocol
    private let settingsManager: SettingsManagerProtocol
    private let vibrateManager: VibrateManagerProtocol

    // MARK: Init
    init(
        cacheManager: CacheManagerProtocol,
        settingsManager: SettingsManagerProtocol,
        vibrateManager: VibrateManagerProtocol
    ) {
        self.cacheManager = cacheManager
        self.settingsManager = settingsManager
        self.vibrateManager = vibrateManager

        bindCacheManager()
        bindVibrateManager()
    }
}

// MARK: - Internal
extension DetailsViewModel {
    func getCachedImage(key: AnyObject) -> Image? {
        cacheManager.getCachedImage(key: key)
    }

    func markAsRead(_ key: String) {
        let isViewed = checkIsRead(key)

        guard !isViewed else { return }

        watchedTopics.append(key)
        clearStorageIfNeeded()
    }

    func markAsUnread(_ key: String) {
        watchedTopics.removeAll(where: { $0 == key })
        clearStorageIfNeeded()
    }

    func cache(object: AnyObject, key: AnyObject) {
        imageCacheData = (object, key)
    }

    func checkIsRead(_ key: String) -> Bool {
        watchedTopics.contains(where: { $0 == key })
    }

    func impactOccured(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        feedbackStyle = style
    }

    func notificationOccurred(_ feedBackType: UINotificationFeedbackGenerator.FeedbackType) {
        self.feedBackType = feedBackType
    }

    func checkIsFavorite(_ article: Article) -> Bool {
        favoriteTopics.contains(article.favorite)
    }
}

// MARK: - Private
private extension DetailsViewModel {
    func bindCacheManager() {
        cacheManager.bind(to: $imageCacheData.eraseToAnyPublisher())
    }

    func bindVibrateManager() {
        vibrateManager.bind(to: $feedbackStyle.eraseToAnyPublisher())
        vibrateManager.bind(to: $feedBackType.eraseToAnyPublisher())
    }

    func clearStorageIfNeeded() {
        guard watchedTopics.count >= Constants.storageCapacity else { return }
        watchedTopics = Array(watchedTopics.dropFirst(Constants.needDropCount))
    }
}
