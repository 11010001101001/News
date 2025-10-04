import Foundation
import Combine
import SwiftUI
import UIKit

final class SettingsViewModel: Observable, ObservableObject {
    @Published var feedBackType: UINotificationFeedbackGenerator.FeedbackType?
    @Published var notificationSound = String.empty
    @Published var id: Int?
    @Published var feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle?
    @Published var loadingFailed = false
    @Published var loadingSucceed = false
    @Published var keyWord: String?
    @Published var cancellables = Set<AnyCancellable>()
    @Published var failureReason = String.empty
    @Published var errorSound = String.empty
    @Published var newsArray = [Article]()

    var savedSettings: [SettingsModel]?

    private(set) var loader: String {
        get { savedSettings?.first?.loader ?? LoaderConfiguration.hourGlass.rawValue }
        set { savedSettings?.first?.loader = newValue }
    }

    private(set) var category: String {
        get { savedSettings?.first?.category ?? Category.technology.rawValue }
        set { savedSettings?.first?.category = newValue }
    }

    private(set) var soundTheme: String {
        get { savedSettings?.first?.soundTheme ?? SoundTheme.silentMode.rawValue }
        set {
            savedSettings?.first?.soundTheme = newValue
            configureNotifications()
        }
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

    var watchedTopics: [String] {
        get { savedSettings?.first?.watchedTopics ?? [] }
        set { savedSettings?.first?.watchedTopics = newValue }
    }

    var loaderShadowColor: Color {
        LoaderConfiguration(rawValue: loader)?.shadowColor ?? .clear
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

    func applySettings(_ name: String) {
        switch name {
        case let name where Category.allCases.contains(where: { $0.rawValue == name }):
            guard name != category else {
                notificationOccurred(.error)
                return
            }
            category = name
            loadNews()
        case let name where SoundTheme.allCases.contains(where: { $0.rawValue == name }):
            guard name != soundTheme else {
                notificationOccurred(.error)
                return
            }
            soundTheme = name
            notificationOccurred(.success)
        case let name where LoaderConfiguration.allCases.contains(where: { $0.rawValue == name }):
            guard name != loader else {
                notificationOccurred(.error)
                return
            }
            loader = name
            redrawContentViewLoader()
            notificationOccurred(.success)
        case let name where AppIconConfiguration.allCases.contains(where: { $0.rawValue == name }):
            guard name != appIcon else {
                notificationOccurred(.error)
                return
            }
            appIcon = name
            notificationOccurred(.success)
        default:
            break
        }
    }

    func checkIsEnabled(_ settingName: String) -> Bool {
        [
            soundTheme,
            category,
            loader,
            appIcon
        ].first(where: { $0 == settingName }) != nil
    }

    func redrawContentViewLoader() {
        id = Int.random(in: .zero...Int.max)
    }

    func impactOccured(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        feedbackStyle = style
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
}
