//
//  SettingsManager.swift
//  News
//
//  Created by Ярослав Куприянов on 28.03.2024.
//

import Foundation
import SwiftUI

protocol SettingsManagerProtocol {
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

    func loadSettings(_ settings: [SettingsModel])
}

final class SettingsManager: SettingsManagerProtocol {
    private var settings: SettingsModel? {
        savedSettings?.first
    }

    private var savedSettings: [SettingsModel]?

    func loadSettings(_ settings: [SettingsModel]) {
        self.savedSettings = settings
        // Updates active localization bundle in SwiftGen Texts class without app restart
        Texts.currentLanguage = language
    }

    var category: String {
        (settings?.category).or(Constants.DefaultSettings.category)
    }

    var soundTheme: String {
        (settings?.soundTheme).or(Constants.DefaultSettings.soundTheme)
    }

    var loader: String {
        (settings?.loader).or(Constants.DefaultSettings.loader)
    }

    var appIcon: String {
        (settings?.appIcon).or(Constants.DefaultSettings.appIcon)
    }

    var language: String {
        (settings?.language).or(Constants.DefaultSettings.language)
    }

    var keyword: String {
        (settings?.keyword).or("")
    }

    var watchedTopics: Set<String> {
        (settings?.watchedTopics).orEmpty
    }

    var favoriteTopics: [FavoriteArticle] {
        sortIsRead((settings?.favoriteTopics).orEmpty)
    }

    var loaderShadowColor: Color {
        LoaderConfiguration(rawValue: loader)?.shadowColor ?? .clear
    }

    func save(category: String) {
        savedSettings?.first?.category = category
    }

    func save(appIcon: String) {
        savedSettings?.first?.appIcon = appIcon

        let iconName = (AppIconConfiguration.init(rawValue: appIcon)?.iconName).orEmpty

        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error {
                print("App icon change notice (\(appIcon)): \(error.localizedDescription)")
            }
        }
    }

    func save(soundTheme: String) {
        savedSettings?.first?.soundTheme = soundTheme
    }

    func save(loader: String) {
        savedSettings?.first?.loader = loader
    }

    func save(language: String) {
        savedSettings?.first?.language = language
        // Updates active localization bundle in SwiftGen Texts class without app restart
        Texts.currentLanguage = language
    }

    func save(watchedTopics: Set<String>) {
        savedSettings?.first?.watchedTopics = watchedTopics
    }

    func save(favorites: [FavoriteArticle]) {
        savedSettings?.first?.favoriteTopics = favorites
    }

    func save(keyword: String) {
        savedSettings?.first?.keyword = keyword
    }

    private func sortIsRead(_ articles: [FavoriteArticle]) -> [FavoriteArticle] {
        var read = [FavoriteArticle]()
        var notRead = [FavoriteArticle]()

        articles.forEach {
            let key = ($0.url).or(($0.title).orEmpty)
            let isRead = checkIsRead(key)
            if isRead {
                read.append($0)
            } else {
                notRead.append($0)
            }
        }

        return notRead + read
    }

    private func checkIsRead(_ key: String) -> Bool {
        watchedTopics.contains(where: { $0 == key })
    }
}
