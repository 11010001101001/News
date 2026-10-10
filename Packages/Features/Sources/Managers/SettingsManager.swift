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
    var category: NewsCategory {
        get { savedSettings?.category ?? .business }
        set { savedSettings?.category = newValue }
    }

    var soundTheme: SoundTheme {
        get { savedSettings?.soundTheme ?? .silentMode }
        set { savedSettings?.soundTheme = newValue }
    }

    var loader: LoaderConfiguration {
        get { savedSettings?.loader ?? .hourGlass }
        set { savedSettings?.loader = newValue }
    }

    var appIcon: AppIconConfiguration {
        get { savedSettings?.appIcon ?? .globe }
        set { savedSettings?.appIcon = newValue }
    }

    var language: AppLanguage {
        get { savedSettings?.language ?? .english }
        set { savedSettings?.language = newValue }
    }

    var keyword: String {
        get { savedSettings?.keyword ?? .empty }
        set { savedSettings?.keyword = newValue }
    }

    var watchedTopics: Set<String> {
        get { savedSettings?.watchedTopics ?? [] }
        set { savedSettings?.watchedTopics = newValue }
    }

    var favoriteTopics: [Article] {
        get { savedSettings?.favoriteTopics ?? [] }
        set { savedSettings?.favoriteTopics = newValue }
    }

    @ObservationIgnored
    private var savedSettings: SettingsModel?

    var isDefaultSettings: Bool {
        category == .business
            && soundTheme == .silentMode
            && loader == .hourGlass
            && appIcon == .globe
    }

    func loadSettings(_ model: SettingsModel) {
        self.savedSettings = model
        self.category = model.category
        self.soundTheme = model.soundTheme
        self.loader = model.loader
        self.appIcon = model.appIcon
        self.language = model.language
        self.keyword = model.keyword
        self.watchedTopics = model.watchedTopics
        self.favoriteTopics = rangeFavorites(model.favoriteTopics)
    }

    func save(category: NewsCategory) {
        self.category = category
    }

    func save(appIcon: AppIconConfiguration) {
        self.appIcon = appIcon
        UIApplication.shared.setAlternateIconName(appIcon.iconName)
    }

    func save(soundTheme: SoundTheme) {
        self.soundTheme = soundTheme
    }

    func save(loader: LoaderConfiguration) {
        self.loader = loader
    }

    func save(language: AppLanguage) {
        self.language = language
    }

    func save(watchedTopics: Set<String>) {
        self.watchedTopics = watchedTopics
        if let savedSettings {
            self.favoriteTopics = rangeFavorites(savedSettings.favoriteTopics)
        }
    }

    func save(favorites: [Article]) {
        self.favoriteTopics = favorites
        if let savedSettings {
            self.favoriteTopics = rangeFavorites(savedSettings.favoriteTopics)
        }
    }

    func save(keyword: String) {
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
