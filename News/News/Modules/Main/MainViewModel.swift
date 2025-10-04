//
//  MainViewModel.swift
//  News
//
//  Created by Ярослав Куприянов on 04.10.2025.
//

import Foundation
import SwiftUI
import Combine

final class MainViewModel: Observable, ObservableObject {
    /// For redraw loader on content view after settings loaded: render loader -> settings loaded -> redraw
    @Published var id: Int?
    @Published var failureReason = String.empty
    @Published var newsArray = [Article]()
    @Published var loadingFailed = false
    @Published var loadingSucceed = false
    @Published var keyWord: String?
    @Published var notificationSound = String.empty
    @Published var feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle?
    @Published var feedBackType: UINotificationFeedbackGenerator.FeedbackType?
    @Published var cancellables = Set<AnyCancellable>()
    @Published var errorSound = String.empty
    @Published var refreshSound = String.empty
    @Published var settingsShortcutItemTapped = false
    @Published var shareShortcutItemTapped = false

    var savedSettings: [SettingsModel]?

    private(set) var loader: String {
        get { savedSettings?.first?.loader ?? LoaderConfiguration.hourGlass.rawValue }
        set { savedSettings?.first?.loader = newValue }
    }

    var loaderShadowColor: Color {
        LoaderConfiguration(rawValue: loader)?.shadowColor ?? .clear
    }

    private(set) var soundTheme: String {
        get { savedSettings?.first?.soundTheme ?? SoundTheme.silentMode.rawValue }
        set {
            savedSettings?.first?.soundTheme = newValue
            configureNotifications()
        }
    }

    private(set) var category: String {
        get { savedSettings?.first?.category ?? Category.technology.rawValue }
        set { savedSettings?.first?.category = newValue }
    }

    private(set) var appIcon: String {
        get { savedSettings?.first?.appIcon ?? AppIconConfiguration.globe.rawValue }
        set {
            savedSettings?.first?.appIcon = newValue

            let iconName = AppIconConfiguration.init(rawValue: newValue)?.iconName ?? .empty

            UIApplication.shared.setAlternateIconName(iconName) { error in
                if let error {
                    fatalError("File \(newValue): \(error.localizedDescription)")
                }
            }
        }
    }

    var isDefaultSettings: Bool {
        category == Constants.DefaultSettings.category &&
        soundTheme == Constants.DefaultSettings.soundTheme &&
        loader == Constants.DefaultSettings.loader &&
        appIcon == Constants.DefaultSettings.appIcon
    }

    // swiftlint:disable line_length
    var newsPublisher: AnyPublisher<(data: Data, response: URLResponse), ApiError> {
        var urlString: String {
            let mode: Mode = keyWord == nil ? .category(category) : .keyword(keyWord ?? .empty)
            return switch mode {
            case .keyword(let keyword):
                "https://newsapi.org/v2/everything?q=\(keyword)&pageSize=\(Constants.newsCount)&language=ru&apiKey=\(DeveloperInfo.apiKey)"
            case .category(let category):
                "https://newsapi.org/v2/top-headlines?country=us&category=\(category)&pageSize=\(Constants.newsCount)&apiKey=\(DeveloperInfo.apiKey)"
            }
        }
        // swiftlint:enable line_length
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.invalidRequest(msg: Errors.invalidUrl))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .retry(3)
            .mapError { [weak self] error in
                self?.mapError(error) ?? ApiError.mappingError(msg: Errors.mappingError)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    func loadNews(
        isRefresh: Bool = false,
        completion: Action? = nil
    ) {
        if !isRefresh {
            loadingSucceed = false
            loadingFailed = false
        }

        newsPublisher
            .sink { [weak self] result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleError(error)
                }
            } receiveValue: { [weak self] value in
                self?.handleResponse(value, completion)
            }
            .store(in: &cancellables)
    }

    func mapError(_ error: Publishers.Retry<URLSession.DataTaskPublisher>.Failure) -> ApiError {
        let urlError = error as URLError
        return switch urlError.errorCode {
        case -1009:
            ApiError.noConnection(msg: Errors.noConnection)
        default:
            ApiError.mappingError(msg: Errors.mappingError)
        }
    }

    func handleError(_ error: ApiError) {
        let message: String

        switch error {
        case let .noConnection(msg):
            message = msg
        case let .mappingError(msg):
            message = msg
        default:
            message = Texts.Errors.unhandled()
        }
        notificationOccurred(.error)
        playError()
        loadingFailed = true
        failureReason = message
    }

    func handleResponse(
        _ value: (data: Data, response: URLResponse),
        _ completion: Action? = nil
    ) {
        guard let response = value.response as? HTTPURLResponse,
              let model = try? JSONDecoder().decode(CommonInfo.self, from: value.data)
        else { return }

        let statusCode = response.statusCode

        switch statusCode {
        case 200:
            notificationOccurred(.success)
            loadingSucceed = true
            newsArray = sortIsRead(model.articles)

        default:
            notificationOccurred(.error)
            playError()
            loadingFailed = true
            failureReason = (HttpStatusCodes(rawValue: statusCode)?.message).orEmpty
        }

        completion??()
    }

    func impactOccured(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        feedbackStyle = style
    }

    func refresh(completion: Action? = nil) {
        playRefresh()
        loadNews(isRefresh: true, completion: completion)
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

    func notificationOccurred(_ feedBackType: UINotificationFeedbackGenerator.FeedbackType) {
        self.feedBackType = feedBackType
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

    var starwarsRefresh: String {
        Set(["starwars_refresh", "starwars_refresh1"]).randomElement() ?? .empty
    }

    var catsRefresh: String {
        Set(["cats_refresh", "cats_refresh1"]).randomElement() ?? .empty
    }

    func checkIsRead(_ key: String) -> Bool {
        watchedTopics.contains(where: { $0 == key })
    }

    var watchedTopics: [String] {
        get { savedSettings?.first?.watchedTopics ?? [] }
        set { savedSettings?.first?.watchedTopics = newValue }
    }

    func markAsUnread(_ key: String) {
        watchedTopics.removeAll(where: { $0 == key })
        clearStorageIfNeeded()
    }

    private func clearStorageIfNeeded() {
        guard watchedTopics.count >= Constants.storageCapacity else { return }
        watchedTopics = Array(watchedTopics.dropFirst(Constants.needDropCount))
    }

    var isAllRead: Bool {
        guard !newsArray.isEmpty else { return false }
        return newsArray.allSatisfy { checkIsRead($0.key) }
    }

    func markAsReadOrUnread() {
        if isAllRead {
            newsArray.forEach { markAsUnread($0.key) }
        } else {
            newsArray.forEach { markAsRead($0.key) }
        }
    }

    func markAsRead(_ key: String) {
        let isViewed = checkIsRead(key)

        guard !isViewed else { return }

        watchedTopics.append(key)
        clearStorageIfNeeded()
    }

    func redrawContentViewLoader() {
        id = Int.random(in: .zero...Int.max)
    }

    var soundManager: SoundManager?
    var vibrateManager: VibrateManager?
    var notificationManager: NotificationManager?

    init() {
        soundManager = SoundManager(viewModel: self)
        vibrateManager = VibrateManager(viewModel: self)
        notificationManager = NotificationManager(viewModel: self)
    }

    deinit {
        soundManager = nil
        vibrateManager = nil
        notificationManager = nil
        cancellables.forEach { $0.cancel() }
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
}
