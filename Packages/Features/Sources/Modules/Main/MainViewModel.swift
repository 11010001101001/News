//
//  MainViewModel.swift
//  News
//
//  Created by Ярослав Куприянов on 04.10.2025.
//

import Foundation
import SwiftUI
import ModelsKit
import CoreKit
import LocalizationKit
import DesignSystem

@Observable
@MainActor
final class MainViewModel {
    // MARK: Internal variables
    var loadingState = LoadingStateModel.loading
    var news = [Article]()
    var settingsShortcutItemTapped = false
    var shareShortcutItemTapped = false

    var loader: LoaderConfiguration {
        get { settingsManager.loader }
        set { settingsManager.save(loader: newValue) }
    }

    var category: NewsCategory {
        get { settingsManager.category }
        set { settingsManager.save(category: newValue) }
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

    var isDefaultSettings: Bool {
        settingsManager.isDefaultSettings
    }

    var isAllRead: Bool {
        guard !news.isEmpty else { return false }
        return news.allSatisfy { checkIsRead($0.key) }
    }

    var hasFavorites: Bool {
        !settingsManager.favoriteTopics.isEmpty
    }

    var isOverheated: Bool {
        thermalManager.isOverheated
    }

    // MARK: Private variables
    private var soundTheme: SoundTheme {
        get { settingsManager.soundTheme }
        set {
            settingsManager.save(soundTheme: newValue)
            configureNotifications()
        }
    }

    private var watchedTopics: Set<String> {
        get { settingsManager.watchedTopics }
        set { settingsManager.save(watchedTopics: newValue) }
    }

    private let soundManager: SoundManagerProtocol
    private let vibrateManager: VibrateManagerProtocol
    private let notificationManager: NotificationManagerProtocol
    private let settingsManager: SettingsManagerProtocol
    private let networkManager: NetworkManagerProtocol
    private let widgetsManager: WidgetsManagerProtocol
    private let thermalManager: ThermalManagerProtocol
    private var loadNewsTask: Task<Void, Never>?

    // MARK: Init
    public init(
        soundManager: SoundManagerProtocol,
        vibrateManager: VibrateManagerProtocol,
        notificationManager: NotificationManagerProtocol,
        settingsManager: SettingsManagerProtocol,
        networkManager: NetworkManagerProtocol,
        widgetsManager: WidgetsManagerProtocol,
        thermalManager: ThermalManagerProtocol
    ) {
        self.soundManager = soundManager
        self.vibrateManager = vibrateManager
        self.notificationManager = notificationManager
        self.settingsManager = settingsManager
        self.networkManager = networkManager
        self.widgetsManager = widgetsManager
        self.thermalManager = thermalManager

        widgetsManager.start()
    }
}

// MARK: - Public
extension MainViewModel {
    func loadSettings(_ model: SettingsModel) {
        settingsManager.loadSettings(model)
        self.loader = model.loader
        self.soundTheme = model.soundTheme
        self.category = model.category
        self.watchedTopics = model.watchedTopics
        self.language = model.language
    }

    public func loadNews(isRefresh: Bool = false) {
        if !isRefresh {
            loadingState = .loading
        }

        loadNewsTask?.cancel()
        loadNewsTask = Task {
            do {
                let loadedArticles = try await networkManager.loadNews(category: category.rawValue)
                guard !Task.isCancelled else { return }
                let sortedNews = sortIsRead(loadedArticles)
                news = sortedNews
                loadingState = .loaded(data: sortedNews)
                widgetsManager.updateArticles(sortedNews)
                widgetsManager.updateLevel(watchedTopics: watchedTopics)
                notificationOccurred(.success)
            } catch is CancellationError {
                return
            } catch let error as ApiError {
                guard !Task.isCancelled else { return }
                let message: LocalizedStringResource =
                    switch error {
                    case .noConnection(let msg): msg
                    case .mappingError(let msg): msg
                    default: Strings.errorsUnhandled
                    }
                loadingState = .error(message: message)
                notificationOccurred(.error)
                playError()
            } catch {
                guard !Task.isCancelled else { return }
                loadingState = .error(message: Strings.errorsUndefinedError)
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
                settingsManager.save(lastViewedTitle: $0.title.orEmpty)
            }
        }
        widgetsManager.updateLevel(watchedTopics: watchedTopics)
    }

    func addShortcutItems() {
        UIApplication.shared.shortcutItems = ShortcutItem.allItems
    }

    public func handleShortcutItemTap(_ name: String) {
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
        Task {
            await notificationManager.configureNotifications(with: soundTheme.notificationSound)
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
        watchedTopics.contains(key)
    }

    fileprivate func notificationOccurred(
        _ feedBackType: UINotificationFeedbackGenerator.FeedbackType
    ) {
        vibrateManager.vibrate(feedBackType)
    }

    fileprivate func playRefresh() {
        guard soundTheme != .silentMode else { return }

        let refreshSound =
            switch soundTheme {
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

    fileprivate func playError() {
        guard soundTheme != .silentMode else { return }

        let errorSound =
            switch soundTheme {
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
