//
//  MainViewModel.swift
//  News
//
//  Created by Ярослав Куприянов on 04.10.2025.
//

import Foundation
import SwiftUI
import Combine

final class MainViewModel: ObservableObject {
    // MARK: Internal variables
    @Published var loadingFailed = false
    @Published var loadingSucceeded = false
    @Published var errorMessage = String.empty
    @Published var newsArray = [Article]()

    /// For redraw loader on content view after settings loaded: render loader -> settings loaded -> redraw
    @Published var id: Int?
    @Published var feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle?
    @Published var feedBackType: UINotificationFeedbackGenerator.FeedbackType?
    @Published var settingsShortcutItemTapped = false
    @Published var shareShortcutItemTapped = false
    @Published var notificationSound = String.empty
    @Published var errorSound = String.empty
    @Published var refreshSound = String.empty

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

    var watchedTopics: [String] {
        get { settingsManager.watchedTopics }
        set { settingsManager.save(watchedTopics: newValue) }
    }

    var loaderShadowColor: Color {
        settingsManager.loaderShadowColor
    }

    var isDefaultSettings: Bool {
        category == Constants.DefaultSettings.category &&
        soundTheme == Constants.DefaultSettings.soundTheme &&
        loader == Constants.DefaultSettings.loader &&
        appIcon == Constants.DefaultSettings.appIcon
    }

    var starwarsRefresh: String {
        Set(["starwars_refresh", "starwars_refresh1"]).randomElement() ?? .empty
    }

    var catsRefresh: String {
        Set(["cats_refresh", "cats_refresh1"]).randomElement() ?? .empty
    }

    var isAllRead: Bool {
        guard !newsArray.isEmpty else { return false }
        return newsArray.allSatisfy { checkIsRead($0.key) }
    }

    // MARK: Private variables
    private let soundManager: SoundManagerProtocol
    private let vibrateManager: VibrateManagerProtocol
    private let notificationManager: NotificationManagerProtocol
    private let settingsManager: SettingsManagerProtocol
    private let networkManager: NetworkManagerProtocol
    private var cancellables = Set<AnyCancellable>()

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

        subscribeNetworkManager()

        bindSoundManager()
        bindVibrateManager()
        bindNotificationManager()
    }
}

// MARK: - Internal
extension MainViewModel {
    func loadSettings(_ settings: [SettingsModel]) {
        settingsManager.loadSettings(settings)
    }

    func loadNews() {
        networkManager.loadNews(category: category, isRefresh: false, completion: nil)
    }

    func markAsReadOrUnread() {
        if isAllRead {
            newsArray.forEach { markAsUnread($0.key) }
        } else {
            newsArray.forEach { markAsRead($0.key) }
        }
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

    func addShortcutItems() {
        UIApplication.shared.shortcutItems = ShortcutItem.allItems
    }

    func redrawContentViewLoader() {
        id = Int.random(in: .zero...Int.max)
    }

    /// sound theme can change - do it during every app launch and sound changing
    func configureNotifications() {
        notificationSound = switch SoundTheme(rawValue: soundTheme) {
        case .starwars:
            "starwars_notification"
        case .cats:
            "cats_notification"
        default:
            String.empty
        }
    }

    func impactOccured(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        feedbackStyle = style
    }

    func refresh(completion: Action? = nil) {
        playRefresh()
        networkManager.loadNews(category: category, isRefresh: true, completion: completion)
    }
}

// MARK: - Private
private extension MainViewModel {
    func subscribeNetworkManager() {
        networkManager.loadingFailed
            .sink { [weak self] in self?.loadingFailed = $0 }
            .store(in: &cancellables)
        networkManager.loadingSucceeded
            .sink { [weak self] in
                self?.loadingSucceeded = $0
                if $0 {
                    self?.notificationOccurred(.success)
                }
            }
            .store(in: &cancellables)
        networkManager.errorMessage
            .sink { [weak self] in
                self?.errorMessage = $0
                self?.notificationOccurred(.error)
                self?.playError()
            }
            .store(in: &cancellables)
        networkManager.newsArray
            .sink { [weak self] in self?.newsArray = (self?.sortIsRead($0)).orEmpty }
            .store(in: &cancellables)
    }

    func bindSoundManager() {
        soundManager.bind(to: $errorSound.eraseToAnyPublisher())
        soundManager.bind(to: $refreshSound.eraseToAnyPublisher())
    }

    func bindVibrateManager() {
        vibrateManager.bind(to: $feedbackStyle.eraseToAnyPublisher())
        vibrateManager.bind(to: $feedBackType.eraseToAnyPublisher())
    }

    func bindNotificationManager() {
        notificationManager.bind(to: $notificationSound.eraseToAnyPublisher())
    }

    func clearStorageIfNeeded() {
        guard watchedTopics.count >= Constants.storageCapacity else { return }
        watchedTopics = Array(watchedTopics.dropFirst(Constants.needDropCount))
    }

    func sortIsRead(_ articles: [Article]?) -> [Article] {
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

    func checkIsRead(_ key: String) -> Bool {
        watchedTopics.contains(where: { $0 == key })
    }

    func markAsUnread(_ key: String) {
        watchedTopics.removeAll(where: { $0 == key })
        clearStorageIfNeeded()
    }

    func markAsRead(_ key: String) {
        let isViewed = checkIsRead(key)

        guard !isViewed else { return }

        watchedTopics.append(key)
        clearStorageIfNeeded()
    }

    func notificationOccurred(_ feedBackType: UINotificationFeedbackGenerator.FeedbackType) {
        self.feedBackType = feedBackType
    }

    func playRefresh() {
        guard soundTheme != SoundTheme.silentMode.rawValue else { return }

        refreshSound = switch SoundTheme(rawValue: soundTheme) {
        case .starwars:
            starwarsRefresh
        case .cats:
            catsRefresh
        default:
            String.empty
        }
    }

    func playError() {
        guard soundTheme != SoundTheme.silentMode.rawValue else { return }

        errorSound = switch SoundTheme(rawValue: soundTheme) {
        case .starwars:
            "starwars_error"
        case .cats:
            "cats_error"
        default:
            String.empty
        }
    }
}
