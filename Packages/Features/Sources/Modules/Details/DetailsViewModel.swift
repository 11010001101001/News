//
//  DetailsViewModel.swift
//  News
//
//  Created by Ярослав Куприянов on 10.10.2025.
//

import CoreKit
import DesignSystem
import Foundation
import LocalizationKit
import ModelsKit
import SwiftUI

@Observable
@MainActor
final class DetailsViewModel {
    // MARK: Public variables
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

    var title: String {
        article.title.orEmpty
    }

    var publishedAt: String {
        (article.publishedAt?.toReadableDate()).orEmpty
    }

    var sourceName: String {
        (article.source?.name).orEmpty
    }

    var url: String {
        article.url.orEmpty
    }

    var cacheKey: AnyObject & Sendable {
        url as AnyObject & Sendable
    }

    var imageUrl: String {
        article.urlToImage.orEmpty
    }

    var description: String {
        article.description ?? String(localized: Strings.stateNoDescription)
    }

    var isFavorite: Bool {
        favoriteTopics.contains(article.favorite)
    }

    var favoriteIcon: String {
        isFavorite ? SFSymbols.heartFill.rawValue : SFSymbols.heart.rawValue
    }

    var isReadTitle: LocalizedStringResource {
        isRead ? Strings.contextMenuMarkAsUnread : Strings.contextMenuMarkAsRead
    }

    var isReadIcon: String {
        isRead ? SFSymbols.checkmarkSealFill.rawValue : SFSymbols.checkmarkSeal.rawValue
    }

    var isRead: Bool {
        checkIsRead(article.key)
    }

    var isShadowEnabled: Bool {
        ((article.title?.lowercased()).orEmpty).contains(keyword.lowercased())
    }

    var favoritesContextMenuTitle: LocalizedStringResource {
        isFavorite ? Strings.contextMenuRemoveFromFavorites : Strings.contextMenuAddToFavorites
    }

    var isThrottled: Bool {
        thermalManager.isOverheated || powerManager.isLowPower
    }

    // MARK: Private variables
    private let cacheManager: CacheManagerProtocol
    private let settingsManager: SettingsManagerProtocol
    private let vibrateManager: VibrateManagerProtocol
    private let widgetsManager: WidgetsManagerProtocol
    private let expertManager: ExpertManagerProtocol
    private let thermalManager: ThermalManagerProtocol
    private let powerManager: PowerManagerProtocol
    private let article: Article

    // MARK: Init
    init(
        cacheManager: CacheManagerProtocol,
        settingsManager: SettingsManagerProtocol,
        vibrateManager: VibrateManagerProtocol,
        widgetsManager: WidgetsManagerProtocol,
        expertManager: ExpertManagerProtocol,
        thermalManager: ThermalManagerProtocol,
        powerManager: PowerManagerProtocol,
        article: Article
    ) {
        self.cacheManager = cacheManager
        self.settingsManager = settingsManager
        self.vibrateManager = vibrateManager
        self.widgetsManager = widgetsManager
        self.expertManager = expertManager
        self.thermalManager = thermalManager
        self.powerManager = powerManager
        self.article = article
    }
}

// MARK: - Private
extension DetailsViewModel {
    fileprivate func markAsUnread() {
        watchedTopics.remove(article.key)
        widgetsManager.updateLevel(watchedTopics: watchedTopics)
    }

    fileprivate func checkIsRead(_ key: String) -> Bool {
        watchedTopics.contains(where: { $0 == key })
    }
}

// MARK: - Public
extension DetailsViewModel {
    func getCachedImage() -> Image? {
        (cacheManager.get(key: cacheKey) as? CacheWrapper<Image>)?.data
    }

    func markAsRead() {
        let isViewed = checkIsRead(article.key)

        guard !isViewed else { return }

        watchedTopics.insert(article.key)
        settingsManager.save(lastViewedTitle: article.title.orEmpty)
        widgetsManager.updateLevel(watchedTopics: watchedTopics)
    }

    func cache(_ image: Image) {
        cacheManager.save(object: CacheWrapper(data: image), key: cacheKey)
    }

    func impactOccured(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        vibrateManager.vibrate(style)
    }

    func toggleFavorite() {
        impactOccured(.light)

        if isFavorite {
            favoriteTopics.removeAll(where: { $0 == article.favorite })
        } else {
            favoriteTopics.append(article.favorite)
        }
    }

    func copyDescription() {
        UIPasteboard.general.string = description
        impactOccured(.medium)
    }

    func generateOpinion() async -> Rating {
        guard !Task.isCancelled else { return .error }

        let key = article.key as AnyObject & Sendable
        if let cached = (cacheManager.get(key: key) as? CacheWrapper<Rating>)?.data {
            return cached
        }

        let result = await expertManager.generateOpinion(from: description)

        guard !Task.isCancelled else { return .error }
        guard result != .cooling else { return .cooling }
        guard result != .lowPower else { return .lowPower }

        cacheManager.save(object: CacheWrapper(data: result), key: key)
        return result
    }

    func markAsReadOrUnread() {
        impactOccured(.light)
        if isRead {
            markAsUnread()
        } else {
            markAsRead()
        }
    }
}
