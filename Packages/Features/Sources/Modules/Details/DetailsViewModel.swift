//
//  DetailsViewModel.swift
//  News
//
//  Created by Ярослав Куприянов on 10.10.2025.
//

import Foundation
import SwiftUI
import ModelsKit
import CoreKit

@Observable
@MainActor
final class DetailsViewModel {
    // MARK: Internal variables
    var imageCacheData: (image: AnyObject, key: AnyObject)?

    var loader: String {
        get { settingsManager.loader }
        set { settingsManager.save(loader: newValue) }
    }

    var watchedTopics: Set<String> {
        get { settingsManager.watchedTopics }
        set { settingsManager.save(watchedTopics: newValue) }
    }

    var favoriteTopics: [FavoriteArticle] {
        get { settingsManager.favoriteTopics }
        set { settingsManager.save(favorites: newValue) }
    }

    var keyword: String {
        settingsManager.keyword
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
    }
}

// MARK: - Public
extension DetailsViewModel {
    func getCachedImage(key: AnyObject & Sendable) async -> Image? {
        await cacheManager.getCachedImage(key: key)
    }

    func markAsRead(_ key: String) {
        let isViewed = checkIsRead(key)

        guard !isViewed else { return }

        watchedTopics.insert(key)
        WidgetsManager.shared.updateLevel(watchedTopics: watchedTopics)
    }

    func markAsUnread(_ key: String) {
        watchedTopics.remove(key)
        WidgetsManager.shared.updateLevel(watchedTopics: watchedTopics)
    }

    func cache(object: AnyObject & Sendable, key: AnyObject & Sendable) {
        imageCacheData = (object, key)
        Task {
            await cacheManager.save(object: object, key: key)
        }
    }

    func checkIsRead(_ key: String) -> Bool {
        watchedTopics.contains(where: { $0 == key })
    }

    func impactOccured(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        vibrateManager.vibrate(style)
    }

    func notificationOccurred(_ feedBackType: UINotificationFeedbackGenerator.FeedbackType) {
        vibrateManager.vibrate(feedBackType)
    }

    func checkIsFavorite(_ article: Article) -> Bool {
        favoriteTopics.contains(article.favorite)
    }
}
