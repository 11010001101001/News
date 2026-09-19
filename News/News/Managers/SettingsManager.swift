//
//  SettingsManager.swift
//  News
//
//  Created by Ярослав Куприянов on 28.03.2024.
//

import Foundation
import SwiftUI

@MainActor
protocol SettingsManagerProtocol: Sendable {
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

@MainActor
final class SettingsManager: SettingsManagerProtocol {
    private var settings: SettingsModel? {
        savedSettings?.first
    }

    private var savedSettings: [SettingsModel]?

    func loadSettings(_ settings: [SettingsModel]) {
        performLoadSettings(settings)
    }

    var category: String {
        getCategory()
    }

    var soundTheme: String {
        getSoundTheme()
    }

    var loader: String {
        getLoader()
    }

    var appIcon: String {
        getAppIcon()
    }

    var language: String {
        getLanguage()
    }

    var keyword: String {
        getKeyword()
    }

    var watchedTopics: Set<String> {
        getWatchedTopics()
    }

    var favoriteTopics: [FavoriteArticle] {
        getFavoriteTopics()
    }

    var loaderShadowColor: Color {
        LoaderConfiguration(rawValue: loader)?.shadowColor ?? .clear
    }

    func save(category: String) {
        setCategory(category)
    }

    func save(appIcon: String) {
        setAppIcon(appIcon)
    }

    func save(soundTheme: String) {
        setSoundTheme(soundTheme)
    }

    func save(loader: String) {
        setLoader(loader)
    }

    func save(language: String) {
        setLanguage(language)
    }

    func save(watchedTopics: Set<String>) {
        setWatchedTopics(watchedTopics)
    }

    func save(favorites: [FavoriteArticle]) {
        setFavorites(favorites)
    }

    func save(keyword: String) {
        setKeyword(keyword)
    }
}

// MARK: - MainActor Implementations
private extension SettingsManager {
    func performLoadSettings(_ settings: [SettingsModel]) {
        self.savedSettings = settings
        let lang = (settings.first?.language).or(Constants.DefaultSettings.language)
        Texts.currentLanguage = lang
    }

    func getCategory() -> String {
        (settings?.category).or(Constants.DefaultSettings.category)
    }

    func getSoundTheme() -> String {
        (settings?.soundTheme).or(Constants.DefaultSettings.soundTheme)
    }

    func getLoader() -> String {
        (settings?.loader).or(Constants.DefaultSettings.loader)
    }

    func getAppIcon() -> String {
        (settings?.appIcon).or(Constants.DefaultSettings.appIcon)
    }

    func getLanguage() -> String {
        (settings?.language).or(Constants.DefaultSettings.language)
    }

    func getKeyword() -> String {
        (settings?.keyword).or("")
    }

    func getWatchedTopics() -> Set<String> {
        (settings?.watchedTopics).orEmpty
    }

    func getFavoriteTopics() -> [FavoriteArticle] {
        sortIsRead((settings?.favoriteTopics).orEmpty)
    }

    func setCategory(_ category: String) {
        savedSettings?.first?.category = category
    }

    func setAppIcon(_ appIcon: String) {
        savedSettings?.first?.appIcon = appIcon
        let iconName = (AppIconConfiguration.init(rawValue: appIcon)?.iconName).orEmpty
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error {
                print("App icon change notice (\(appIcon)): \(error.localizedDescription)")
            }
        }
    }

    func setSoundTheme(_ soundTheme: String) {
        savedSettings?.first?.soundTheme = soundTheme
    }

    func setLoader(_ loader: String) {
        savedSettings?.first?.loader = loader
    }

    func setLanguage(_ language: String) {
        savedSettings?.first?.language = language
        Texts.currentLanguage = language
    }

    func setWatchedTopics(_ watchedTopics: Set<String>) {
        savedSettings?.first?.watchedTopics = watchedTopics
    }

    func setFavorites(_ favorites: [FavoriteArticle]) {
        savedSettings?.first?.favoriteTopics = favorites
    }

    func setKeyword(_ keyword: String) {
        savedSettings?.first?.keyword = keyword
    }

    func sortIsRead(_ articles: [FavoriteArticle]) -> [FavoriteArticle] {
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

    func checkIsRead(_ key: String) -> Bool {
        watchedTopics.contains(where: { $0 == key })
    }
}
