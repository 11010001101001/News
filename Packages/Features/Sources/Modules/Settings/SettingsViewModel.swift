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
import DesignSystem

@Observable
@MainActor
public final class SettingsViewModel {
    var loader: LoaderConfiguration {
        get { settingsManager.loader }
        set {
            guard newValue != loader else {
                notificationOccurred(.error)
                return
            }
            settingsManager.save(loader: newValue)
            notificationOccurred(.success)
        }
    }

    var soundTheme: SoundTheme {
        get { settingsManager.soundTheme }
        set {
            guard newValue != soundTheme else {
                notificationOccurred(.error)
                return
            }
            settingsManager.save(soundTheme: newValue)
            notificationOccurred(.success)
            configureNotifications()
        }
    }

    var category: NewsCategory {
        get { settingsManager.category }
        set {
            guard newValue != category else {
                notificationOccurred(.error)
                return
            }
            settingsManager.save(category: newValue)
        }
    }

    var appIcon: AppIconConfiguration {
        get { settingsManager.appIcon }
        set {
            guard newValue != appIcon else {
                notificationOccurred(.error)
                return
            }
            settingsManager.save(appIcon: newValue)
            notificationOccurred(.success)
        }
    }

    var language: AppLanguage {
        get { settingsManager.language }
        set {
            guard newValue != language else {
                notificationOccurred(.error)
                return
            }
            settingsManager.save(language: newValue)
            notificationOccurred(.success)
        }
    }

    var watchedTopics: Set<String> {
        get { settingsManager.watchedTopics }
        set { settingsManager.save(watchedTopics: newValue) }
    }

    var keyword: String {
        get { settingsManager.keyword }
        set { settingsManager.save(keyword: newValue) }
    }

    var entry: Entry {
        let (lvl, procentsToNextLevel) = widgetsManager.getUserLevel(watchedTopics)
        return .init(
            category: category.displayName,
            level: lvl,
            procentsToNextLevel: procentsToNextLevel,
            lastViewedTitle: .empty
        )
    }

    // MARK: Private variables
    private let soundManager: SoundManagerProtocol
    private let vibrateManager: VibrateManagerProtocol
    private let notificationManager: NotificationManagerProtocol
    private let settingsManager: SettingsManagerProtocol
    private let widgetsManager: WidgetsManagerProtocol

    // MARK: Init
    public init(
        soundManager: SoundManagerProtocol,
        vibrateManager: VibrateManagerProtocol,
        notificationManager: NotificationManagerProtocol,
        settingsManager: SettingsManagerProtocol,
        widgetsManager: WidgetsManagerProtocol
    ) {
        self.soundManager = soundManager
        self.vibrateManager = vibrateManager
        self.notificationManager = notificationManager
        self.settingsManager = settingsManager
        self.widgetsManager = widgetsManager
    }
}

// MARK: - Public
extension SettingsViewModel {
    func impactOccured(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        vibrateManager.vibrate(style)
    }

    public func notificationOccurred(
        _ feedBackType: UINotificationFeedbackGenerator.FeedbackType
    ) {
        vibrateManager.vibrate(feedBackType)
    }

    public func playRefresh(theme: SoundTheme) {
        let refreshSound =
            switch theme {
            case .starwars:
                Set(["starwars_refresh", "starwars_refresh1"]).randomElement().orEmpty
            case .cats:
                Set(["cats_refresh", "cats_refresh1"]).randomElement().orEmpty
            default:
                String.empty
            }
        if !refreshSound.isEmpty {
            soundManager.play(refreshSound)
        }
    }
}

// MARK: - Private
extension SettingsViewModel {
    /// sound theme can change - do it during every app launch and sound changing
    fileprivate func configureNotifications() {
        Task {
            await notificationManager.configureNotifications(
                with: soundTheme.notificationSound
            )
        }
    }
}
