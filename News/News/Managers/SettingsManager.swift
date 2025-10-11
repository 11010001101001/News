//
//  SettingsManager.swift
//  News
//
//  Created by Ярослав Куприянов on 10.10.2025.
//

import UIKit
import SwiftUI

protocol SettingsManagerProtocol {
    var soundTheme: String { get }
    var category: String { get }
    var loader: String { get }
    var appIcon: String { get }
    var watchedTopics: [String] { get }
    var loaderShadowColor: Color { get }

    func save(soundTheme: String)
    func save(category: String)
    func save(loader: String)
    func save(appIcon: String)
    func save(watchedTopics: [String])

    func loadSettings(_ settings: [SettingsModel])
}

final class SettingsManager {
    private var savedSettings: [SettingsModel]?
    private var settings: SettingsModel? { savedSettings?.first }
}

// MARK: - SettingsManagerProtocol
extension SettingsManager: SettingsManagerProtocol {
    var soundTheme: String {
        (settings?.soundTheme).or(SoundTheme.silentMode.rawValue)
    }

    var category: String {
        (settings?.category).or(NewsCategory.technology.rawValue)
    }

    var loader: String {
        (settings?.loader).or(LoaderConfiguration.hourGlass.rawValue)
    }

    var appIcon: String {
        (settings?.appIcon).or(AppIconConfiguration.globe.rawValue)
    }

    var watchedTopics: [String] {
        (settings?.watchedTopics).orEmpty
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
                fatalError("File \(appIcon): \(error.localizedDescription)")
            }
        }
    }

    func save(soundTheme: String) {
        savedSettings?.first?.soundTheme = soundTheme
    }

    func save(loader: String) {
        savedSettings?.first?.loader = loader
    }

    func save(watchedTopics: [String]) {
        savedSettings?.first?.watchedTopics = watchedTopics
    }

    func loadSettings(_ settings: [SettingsModel]) {
        savedSettings = settings
    }
}
