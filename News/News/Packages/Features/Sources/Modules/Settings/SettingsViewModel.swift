//
//  SettingsViewModel.swift
//  News
//
//  Created by Ярослав Куприянов on 10.10.2025.
//

import Foundation
import SwiftUI
import UIKit
import ModelsKit
import CoreKit

@Observable
@MainActor
final class SettingsViewModel {
    var loader: String {
        get { settingsManager.loader }
        set { settingsManager.save(loader: newValue) }
    }

    var soundTheme: String {
        get { settingsManager.soundTheme }
        set {
            settingsManager.save(soundTheme: newValue)
            configureNotifications()
        }
    }

    var category: String {
        get { settingsManager.category }
        set { settingsManager.save(category: newValue) }
    }

    var appIcon: String {
        get { settingsManager.appIcon }
        set { settingsManager.save(appIcon: newValue) }
    }

    var language: String {
        get { settingsManager.language }
        set { settingsManager.save(language: newValue) }
    }

    var currentLanguageItem: AppLanguage {
        AppLanguage(rawValue: language) ?? .english
    }

    var availableLanguages: [AppLanguage] {
        AppLanguage.allCases
    }

    var watchedTopics: Set<String> {
        get { settingsManager.watchedTopics }
        set { settingsManager.save(watchedTopics: newValue) }
    }

    var keyword: String {
        get { settingsManager.keyword }
        set { settingsManager.save(keyword: newValue) }
    }

    var loaderShadowColor: Color {
        settingsManager.loaderShadowColor
    }

    // MARK: Private variables
    private let soundManager: SoundManagerProtocol
    private let vibrateManager: VibrateManagerProtocol
    private let notificationManager: NotificationManagerProtocol
    private let settingsManager: SettingsManagerProtocol
    private let networkManager: NetworkManagerProtocol

    // MARK: Init
    init(
        soundManager: SoundManagerProtocol,
        vibrateManager: VibrateManagerProtocol,
        notificationManager: NotificationManagerProtocol,
        settingsManager: SettingsManagerProtocol,
        networkManager: NetworkManagerProtocol
    ) {
        self.soundManager = soundManager
        self.vibrateManager = vibrateManager
        self.notificationManager = notificationManager
        self.settingsManager = settingsManager
        self.networkManager = networkManager
    }
}

// MARK: - Public
extension SettingsViewModel {
    func impactOccured(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        vibrateManager.vibrate(style)
    }

    func checkIsEnabled(_ settingName: String) -> Bool {
        [
            soundTheme,
            category,
            loader,
            appIcon,
            language,
        ].first(where: { $0 == settingName }) != nil
    }

    func applySettings(_ key: String) {
        switch key {
        case let name
        where NewsCategory.allCases.contains(where: { $0.rawValue == name }):
            guard name != category else {
                notificationOccurred(.error)
                return
            }
            category = name

        case let name
        where SoundTheme.allCases.contains(where: { $0.rawValue == name }):
            guard name != soundTheme else {
                notificationOccurred(.error)
                return
            }
            soundTheme = name
            notificationOccurred(.success)

        case let name
        where LoaderConfiguration.allCases.contains(where: {
            $0.rawValue == name
        }):
            guard name != loader else {
                notificationOccurred(.error)
                return
            }
            loader = name
            notificationOccurred(.success)

        case let name
        where AppIconConfiguration.allCases.contains(where: {
            $0.rawValue == name
        }):
            guard name != appIcon else {
                notificationOccurred(.error)
                return
            }
            appIcon = name
            notificationOccurred(.success)

        case let name
        where AppLanguage.allCases.contains(where: { $0.rawValue == name }):
            guard name != language else {
                notificationOccurred(.error)
                return
            }
            language = name
            notificationOccurred(.success)

        default:
            break
        }
    }

    func applyKeyword(_ value: String) {
        playBubble()
        keyword = value
        notificationOccurred(.success)
    }
}

// MARK: - Private
extension SettingsViewModel {
    /// sound theme can change - do it during every app launch and sound changing
    fileprivate func configureNotifications() {
        let notificationSound =
            (SoundTheme(rawValue: soundTheme)?.notificationSound).orEmpty
        Task {
            await notificationManager.configureNotifications(
                with: notificationSound
            )
        }
    }

    fileprivate func notificationOccurred(
        _ feedBackType: UINotificationFeedbackGenerator.FeedbackType
    ) {
        vibrateManager.vibrate(feedBackType)
    }

    fileprivate func playError() {
        guard soundTheme != SoundTheme.silentMode.rawValue else { return }

        let errorSound =
            switch SoundTheme(rawValue: soundTheme) {
            case .starwars:
                "starwars_error"
            case .cats:
                "cats_error"
            default:
                String.empty
            }
        if !errorSound.isEmpty {
            soundManager.play(errorSound)
        }
    }

    fileprivate func playBubble() {
        guard soundTheme != SoundTheme.silentMode.rawValue else { return }
        soundManager.play("bubble")
    }
}
