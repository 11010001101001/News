//
//  MainViewModel.swift
//  News
//
//  Created by Ярослав Куприянов on 04.10.2025.
//

import Foundation
import SwiftUI

@Observable
@MainActor
final class MainViewModel {
    // MARK: Internal variables
    var loadingState = LoadingState.loading
    var news = [Article]()
    var settingsShortcutItemTapped = false
    var shareShortcutItemTapped = false

    var loader: String {
        get { settingsManager.loader }
        set { settingsManager.save(loader: newValue) }
    }

    var loaderShadowColor: Color {
        settingsManager.loaderShadowColor
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

    var watchedTopics: Set<String> {
        get { settingsManager.watchedTopics }
        set { settingsManager.save(watchedTopics: newValue) }
    }

    var isDefaultSettings: Bool {
        category == Constants.DefaultSettings.category
            && soundTheme == Constants.DefaultSettings.soundTheme
            && loader == Constants.DefaultSettings.loader
            && appIcon == Constants.DefaultSettings.appIcon
    }

    var starwarsRefresh: String {
        Set(["starwars_refresh", "starwars_refresh1"]).randomElement().orEmpty
    }

    var catsRefresh: String {
        Set(["cats_refresh", "cats_refresh1"]).randomElement().orEmpty
    }

    var isAllRead: Bool {
        guard !news.isEmpty else { return false }
        return news.allSatisfy { checkIsRead($0.key) }
    }

    var hasFavorites: Bool {
        !settingsManager.favoriteTopics.isEmpty
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

        WidgetsManager.shared.start()
    }
}

// MARK: - Public
extension MainViewModel {
    func loadSettings(_ settings: [SettingsModel]) {
        settingsManager.loadSettings(settings)
    }

    func loadNews(isRefresh: Bool = false) {
        if !isRefresh {
            loadingState = .loading
        }

        Task {
            do {
                let loadedArticles = try await networkManager.loadNews(category: category)
                let sortedNews = sortIsRead(loadedArticles)
                self.news = sortedNews
                self.loadingState = .loaded(data: sortedNews)
                WidgetsManager.shared.updateArticles(sortedNews)
                WidgetsManager.shared.updateLevel(watchedTopics: watchedTopics)
                notificationOccurred(.success)
            } catch let error as ApiError {
                let message: LocalizedStringResource =
                    switch error {
                    case .noConnection(let msg): msg
                    case .mappingError(let msg): msg
                    default: .errorsUnhandled
                    }
                self.loadingState = .error(message: message)
                notificationOccurred(.error)
                playError()
            } catch {
                self.loadingState = .error(message: .errorsUndefinedError)
                notificationOccurred(.error)
                playError()
            }
        }
    }

    func markAsReadOrUnread() {
        if isAllRead {
            news.forEach {
                watchedTopics.remove($0.key)
            }
        } else {
            news.forEach {
                let isViewed = checkIsRead($0.key)
                guard !isViewed else { return }
                watchedTopics.insert($0.key)
            }
        }
        WidgetsManager.shared.updateLevel(watchedTopics: watchedTopics)
    }

    func addShortcutItems() {
        UIApplication.shared.shortcutItems = ShortcutItem.allItems
    }

    func handleShortcutItemTap(_ name: String) {
        switch name {
        case ShortcutItem.settings.rawValue:
            settingsShortcutItemTapped.toggle()
        case ShortcutItem.share.rawValue:
            shareShortcutItemTapped.toggle()
        default:
            break
        }
    }

    /// sound theme can change - do it during every app launch and sound changing
    func configureNotifications() {
        let notificationSound = (SoundTheme(rawValue: soundTheme)?.notificationSound).orEmpty
        Task {
            await notificationManager.configureNotifications(with: notificationSound)
        }
    }

    func impactOccured(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        vibrateManager.vibrate(style)
    }

    func refresh() {
        playRefresh()
        loadNews(isRefresh: true)
    }
}

// MARK: - Private
extension MainViewModel {
    fileprivate func sortIsRead(_ articles: [Article]?) -> [Article] {
        var read = [Article]()
        var notRead = [Article]()

        articles?.forEach {
            guard !$0.title.orEmpty.contains("Removed") else { return }
            let isRead = checkIsRead($0.key)
            if isRead {
                read.append($0)
            } else {
                notRead.append($0)
            }
        }

        return notRead + read
    }

    fileprivate func checkIsRead(_ key: String) -> Bool {
        watchedTopics.contains(where: { $0 == key })
    }

    fileprivate func markAsUnread(_ key: String) {
        watchedTopics.remove(key)
        WidgetsManager.shared.updateLevel(watchedTopics: watchedTopics)
    }

    fileprivate func markAsRead(_ key: String) {
        let isViewed = checkIsRead(key)

        guard !isViewed else { return }

        watchedTopics.insert(key)
        WidgetsManager.shared.updateLevel(watchedTopics: watchedTopics)
    }

    fileprivate func notificationOccurred(
        _ feedBackType: UINotificationFeedbackGenerator.FeedbackType
    ) {
        vibrateManager.vibrate(feedBackType)
    }

    fileprivate func playRefresh() {
        guard soundTheme != SoundTheme.silentMode.rawValue else { return }

        let refreshSound =
            switch SoundTheme(rawValue: soundTheme) {
            case .starwars:
                starwarsRefresh
            case .cats:
                catsRefresh
            default:
                String.empty
            }
        if !refreshSound.isEmpty {
            soundManager.play(refreshSound)
        }
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
}
