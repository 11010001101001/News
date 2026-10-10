//
//  SettingsManager.swift
//  News
//
//  Created by Ярослав Куприянов on 28.03.2024.
//

import DesignSystem
import Foundation
import ModelsKit
import SwiftUI

@MainActor
public protocol SettingsManagerProtocol: Sendable {
    var category: NewsCategory { get }
    var soundTheme: SoundTheme { get }
    var loader: LoaderConfiguration { get }
    var appIcon: AppIconConfiguration { get }
    var language: AppLanguage { get }
    var watchedTopics: Set<String> { get }
    var favoriteTopics: [FavoriteArticle] { get }
    var keyword: String { get }
    var isDefaultSettings: Bool { get }

    func save(category: NewsCategory)
    func save(soundTheme: SoundTheme)
    func save(loader: LoaderConfiguration)
    func save(appIcon: AppIconConfiguration)
    func save(language: AppLanguage)
    func save(watchedTopics: Set<String>)
    func save(favorites: [FavoriteArticle])
    func save(keyword: String)
    func save(lastViewedTitle: String)

    func loadSettings(_ settings: [SettingsModel])
}

@MainActor
@Observable
final class SettingsManager: SettingsManagerProtocol {
    var category = NewsCategory.business
    var soundTheme = SoundTheme.silentMode
    var loader = LoaderConfiguration.hourGlass
    var appIcon = AppIconConfiguration.globe
    var language = AppLanguage.english
    var keyword: String = ""
    var watchedTopics: Set<String> = []
    var favoriteTopics: [FavoriteArticle] = []

    @ObservationIgnored
    private var savedSettings: [SettingsModel]?

    var isDefaultSettings: Bool {
        category == .business
            && soundTheme == .silentMode
            && loader == .hourGlass
        && appIcon == .globe
    }

    func loadSettings(_ settings: [SettingsModel]) {
        self.savedSettings = settings
        if let model = settings.first {
            self.category = model.category
            self.soundTheme = model.soundTheme
            self.loader = model.loader
            self.appIcon = model.appIcon
            self.language = model.language
            self.keyword = model.keyword
            self.watchedTopics = model.watchedTopics
            self.favoriteTopics = computeFavorites(model.favoriteTopics)
        }
    }

    func save(category: NewsCategory) {
        self.category = category
        savedSettings?.first?.category = category
    }

    func save(appIcon: AppIconConfiguration) {
        self.appIcon = appIcon
        savedSettings?.first?.appIcon = appIcon
        UIApplication.shared.setAlternateIconName(appIcon.iconName)
    }

    func save(soundTheme: SoundTheme) {
        self.soundTheme = soundTheme
        savedSettings?.first?.soundTheme = soundTheme
    }

    func save(loader: LoaderConfiguration) {
        self.loader = loader
        savedSettings?.first?.loader = loader
    }

    func save(language: AppLanguage) {
        self.language = language
        savedSettings?.first?.language = language
    }

    func save(watchedTopics: Set<String>) {
        self.watchedTopics = watchedTopics
        savedSettings?.first?.watchedTopics = watchedTopics
        if let model = savedSettings?.first {
            self.favoriteTopics = computeFavorites(model.favoriteTopics)
        }
    }

    func save(favorites: [FavoriteArticle]) {
        savedSettings?.first?.favoriteTopics = favorites
        if let model = savedSettings?.first {
            self.favoriteTopics = computeFavorites(model.favoriteTopics)
        }
    }

    func save(keyword: String) {
        self.keyword = keyword
        savedSettings?.first?.keyword = keyword
    }

    func save(lastViewedTitle: String) {
        savedSettings?.first?.lastViewedTitle = lastViewedTitle
    }

    private func computeFavorites(_ favorites: [FavoriteArticle]) -> [FavoriteArticle] {
        var read = [FavoriteArticle]()
        var notRead = [FavoriteArticle]()

        favorites.forEach {
            let key = ($0.url).or(($0.title).orEmpty)
            let isRead = watchedTopics.contains(key)
            if isRead {
                read.append($0)
            } else {
                notRead.append($0)
            }
        }

        return notRead + read
    }
}
