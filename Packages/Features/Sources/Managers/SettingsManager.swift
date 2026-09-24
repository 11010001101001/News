//
//  SettingsManager.swift
//  News
//
//  Created by Ярослав Куприянов on 28.03.2024.
//

import Foundation
import SwiftUI
import ModelsKit
import DesignSystem

@MainActor
public protocol SettingsManagerProtocol: Sendable {
    var category: String { get }
    var soundTheme: String { get }
    var loader: String { get }
    var appIcon: String { get }
    var language: String { get }
    var watchedTopics: Set<String> { get }
    var favoriteTopics: [FavoriteArticle] { get }
    var loaderShadowColor: Color { get }
    var keyword: String { get }

    func save(category: String)
    func save(soundTheme: String)
    func save(loader: String)
    func save(appIcon: String)
    func save(language: String)
    func save(watchedTopics: Set<String>)
    func save(favorites: [FavoriteArticle])
    func save(keyword: String)
    func save(lastViewedTitle: String)

    func loadSettings(_ settings: [SettingsModel])
}

@MainActor
@Observable
final class SettingsManager: SettingsManagerProtocol {
    var category: String = DefaultSettings.category
    var soundTheme: String = DefaultSettings.soundTheme
    var loader: String = DefaultSettings.loader
    var appIcon: String = DefaultSettings.appIcon
    var language: String = DefaultSettings.language
    var keyword: String = ""
    var watchedTopics: Set<String> = []
    var favoriteTopics: [FavoriteArticle] = []

    @ObservationIgnored
    private var savedSettings: [SettingsModel]?

    var loaderShadowColor: Color {
        LoaderConfiguration(rawValue: loader)?.shadowColor ?? .clear
    }

    func loadSettings(_ settings: [SettingsModel]) {
        self.savedSettings = settings
        if let model = settings.first {
            self.category = model.category
            self.soundTheme = model.soundTheme
            self.loader = model.loader
            self.appIcon = model.appIcon
            self.language = model.language.or(DefaultSettings.language)
            self.keyword = model.keyword
            self.watchedTopics = model.watchedTopics
            self.favoriteTopics = computeFavorites(model.favoriteTopics)
        }
    }

    func save(category: String) {
        self.category = category
        savedSettings?.first?.category = category
    }

    func save(appIcon: String) {
        self.appIcon = appIcon
        savedSettings?.first?.appIcon = appIcon
        let iconName = (AppIconConfiguration(rawValue: appIcon)?.iconName).orEmpty
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error {
                print("App icon change notice (\(appIcon)): \(error.localizedDescription)")
            }
        }
    }

    func save(soundTheme: String) {
        self.soundTheme = soundTheme
        savedSettings?.first?.soundTheme = soundTheme
    }

    func save(loader: String) {
        self.loader = loader
        savedSettings?.first?.loader = loader
    }

    func save(language: String) {
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
            let isRead = watchedTopics.contains(where: { $0 == key })
            if isRead {
                read.append($0)
            } else {
                notRead.append($0)
            }
        }

        return notRead + read
    }
}
