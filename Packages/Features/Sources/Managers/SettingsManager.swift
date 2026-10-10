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
    var favoriteTopics: [Article] { get }
    var keyword: String { get }
    var isDefaultSettings: Bool { get }

    func save(category: NewsCategory)
    func save(soundTheme: SoundTheme)
    func save(loader: LoaderConfiguration)
    func save(appIcon: AppIconConfiguration)
    func save(language: AppLanguage)
    func save(watchedTopics: Set<String>)
    func save(favorites: [Article])
    func save(keyword: String)
    func save(lastViewedTitle: String)

    func loadSettings(_ model: SettingsModel)
}

@MainActor
@Observable
final class SettingsManager: SettingsManagerProtocol {
    private(set) var category = NewsCategory.business
    private(set) var soundTheme = SoundTheme.silentMode
    private(set) var loader = LoaderConfiguration.hourGlass
    private(set) var appIcon = AppIconConfiguration.globe
    private(set) var language = AppLanguage.english
    private(set) var keyword = String.empty
    private(set) var watchedTopics = Set<String>()
    private(set) var favoriteTopics = [Article]()

    @ObservationIgnored
    private var savedSettings: SettingsModel?

    var isDefaultSettings: Bool {
        category == .business
            && soundTheme == .silentMode
            && loader == .hourGlass
            && appIcon == .globe
    }

    func loadSettings(_ model: SettingsModel) {
        savedSettings = model
        category = model.category
        soundTheme = model.soundTheme
        loader = model.loader
        appIcon = model.appIcon
        language = model.language
        keyword = model.keyword
        watchedTopics = model.watchedTopics
        favoriteTopics = rangeFavorites(model.favoriteTopics)
    }

    func save(category: NewsCategory) {
        savedSettings?.category = category
        self.category = category
    }

    func save(appIcon: AppIconConfiguration) {
        savedSettings?.appIcon = appIcon
        self.appIcon = appIcon
        UIApplication.shared.setAlternateIconName(appIcon.iconName)
    }

    func save(soundTheme: SoundTheme) {
        savedSettings?.soundTheme = soundTheme
        self.soundTheme = soundTheme
    }

    func save(loader: LoaderConfiguration) {
        savedSettings?.loader = loader
        self.loader = loader
    }

    func save(language: AppLanguage) {
        savedSettings?.language = language
        self.language = language
    }

    func save(watchedTopics: Set<String>) {
        savedSettings?.watchedTopics = watchedTopics
        self.watchedTopics = watchedTopics
        if let savedSettings {
            self.favoriteTopics = rangeFavorites(savedSettings.favoriteTopics)
        }
    }

    func save(favorites: [Article]) {
        savedSettings?.favoriteTopics = favorites
        self.favoriteTopics = favorites
        if let savedSettings {
            self.favoriteTopics = rangeFavorites(savedSettings.favoriteTopics)
        }
    }

    func save(keyword: String) {
        savedSettings?.keyword = keyword
        self.keyword = keyword
    }

    func save(lastViewedTitle: String) {
        savedSettings?.lastViewedTitle = lastViewedTitle
    }

    private func rangeFavorites(_ favorites: [Article]) -> [Article] {
        var read = [Article]()
        var notRead = [Article]()
        let watchedTopics = self.watchedTopics

        favorites.forEach {
            let isRead = watchedTopics.contains($0.key)
            if isRead {
                read.append($0)
            } else {
                notRead.append($0)
            }
        }

        return notRead + read
    }
}
