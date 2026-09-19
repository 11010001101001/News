import Foundation
import Combine
import SwiftUI
import UIKit

final class SettingsViewModel: ObservableObject {
    // MARK: Internal variables
    @Published var loadingState = LoadingState.loading

    @Published var notificationSound = String.empty
    @Published var errorSound = String.empty
    @Published var bubbleSound = String.empty

    @Published var id: Int?

    @Published var feedBackType: UINotificationFeedbackGenerator.FeedbackType?
    @Published var feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle?

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

// MARK: - Public
extension SettingsViewModel {
    func impactOccured(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        feedbackStyle = style
    }

    func checkIsEnabled(_ settingName: String) -> Bool {
        [
            soundTheme,
            category,
            loader,
            appIcon,
            language
        ].first(where: { $0 == settingName }) != nil
    }

    func displayName(for id: String) -> String {
        switch id {
        case NewsCategory.business.rawValue: Texts.Category.business()
        case NewsCategory.entertainment.rawValue: Texts.Category.entertainment()
        case NewsCategory.general.rawValue: Texts.Category.general()
        case NewsCategory.health.rawValue: Texts.Category.health()
        case NewsCategory.science.rawValue: Texts.Category.science()
        case NewsCategory.sports.rawValue: Texts.Category.sports()
        case NewsCategory.technology.rawValue: Texts.Category.technology()

        case SoundTheme.starwars.rawValue: Texts.Sound.starwars()
        case SoundTheme.cats.rawValue: Texts.Sound.cats()
        case SoundTheme.silentMode.rawValue: Texts.Sound.silentMode()

        case LoaderConfiguration.rocket.rawValue: Texts.Loader.rocket()
        case LoaderConfiguration.hourGlass.rawValue: Texts.Loader.hourglass()
        case LoaderConfiguration.astronaut.rawValue: Texts.Loader.astronaut()
        case LoaderConfiguration.hamster.rawValue: Texts.Loader.hamster()
        case LoaderConfiguration.kitten.rawValue: Texts.Loader.kitten()

        case AppIconConfiguration.globe.rawValue: Texts.AppIcon.globe()
        case AppIconConfiguration.cat.rawValue: Texts.AppIcon.cat()
        case AppIconConfiguration.dart.rawValue: Texts.AppIcon.dart()

        case AppLanguage.english.rawValue: AppLanguage.english.title
        case AppLanguage.russian.rawValue: AppLanguage.russian.title
        case AppLanguage.indonesian.rawValue: AppLanguage.indonesian.title

        default: id.capitalizingFirstLetter()
        }
    }

    func applySettings(_ key: String) {
        switch key {
        case let name where NewsCategory.allCases.contains(where: { $0.rawValue == name }):
            guard name != category else {
                notificationOccurred(.error)
                return
            }
            category = name
            networkManager.loadNews(category: category, isRefresh: false)

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

        case let name where AppLanguage.allCases.contains(where: { $0.rawValue == name }):
            guard name != language else {
                notificationOccurred(.error)
                return
            }
            language = name
            notificationOccurred(.success)
            redrawContentViewLoader()

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
private extension SettingsViewModel {
    func subscribeNetworkManager() {
        networkManager.loadingState
            .sink { [weak self] in
                self?.loadingState = $0
                switch $0 {
                case .loading:
                    break
                case .loaded:
                    self?.notificationOccurred(.success)
                case .error:
                    self?.notificationOccurred(.error)
                    self?.playError()
                }
            }
            .store(in: &cancellables)
    }

    func bindSoundManager() {
        soundManager.bind(to: $errorSound.eraseToAnyPublisher())
        soundManager.bind(to: $bubbleSound.eraseToAnyPublisher())
    }

    func bindVibrateManager() {
        vibrateManager.bind(to: $feedbackStyle.eraseToAnyPublisher())
        vibrateManager.bind(to: $feedBackType.eraseToAnyPublisher())
    }

    func bindNotificationManager() {
        notificationManager.bind(to: $notificationSound.eraseToAnyPublisher())
    }

    /// sound theme can change - do it during every app launch and sound changing
    func configureNotifications() {
        notificationSound = (SoundTheme(rawValue: soundTheme)?.notificationSound).orEmpty
    }

    func notificationOccurred(_ feedBackType: UINotificationFeedbackGenerator.FeedbackType) {
        self.feedBackType = feedBackType
    }

    /// Triggers view hierarchy re-evaluation to apply updated localized strings or loader animations
    func redrawContentViewLoader() {
        id = Int.random(in: .zero...Int.max)
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

    func playBubble() {
        guard soundTheme != SoundTheme.silentMode.rawValue else { return }
        bubbleSound = "bubble"
    }
}
