//
//  NewsUnitTests.swift
//  NewsTests
//
//  Created by Yaroslav Kupriyanov on 19.09.2026.
//

import Testing
import Foundation
import SwiftUI
@testable import News

// MARK: - Mocks
private final class MockSoundManager: SoundManagerProtocol, @unchecked Sendable {
    var playedSound: String?
    func play(_ name: String) {
        playedSound = name
    }
}

private final class MockVibrateManager: VibrateManagerProtocol, @unchecked Sendable {
    var vibratedStyle: UIImpactFeedbackGenerator.FeedbackStyle?
    var vibratedType: UINotificationFeedbackGenerator.FeedbackType?

    @MainActor
    func vibrate(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        vibratedStyle = style
    }

    @MainActor
    func vibrate(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        vibratedType = type
    }
}

private final class MockNotificationManager: NotificationManagerProtocol, @unchecked Sendable {
    var configuredSound: String?
    func configureNotifications(with sound: String) async {
        configuredSound = sound
    }
}

private final class MockSettingsManager: SettingsManagerProtocol, @unchecked Sendable {
    var category: String = Constants.DefaultSettings.category
    var soundTheme: String = Constants.DefaultSettings.soundTheme
    var loader: String = Constants.DefaultSettings.loader
    var appIcon: String = Constants.DefaultSettings.appIcon
    var language: String = Constants.DefaultSettings.language
    var watchedTopics: Set<String> = []
    var favoriteTopics: [FavoriteArticle] = []
    var loaderShadowColor: Color = .clear
    var keyword: String = ""

    func save(category: String) { self.category = category }
    func save(soundTheme: String) { self.soundTheme = soundTheme }
    func save(loader: String) { self.loader = loader }
    func save(appIcon: String) { self.appIcon = appIcon }
    func save(language: String) { self.language = language }
    func save(watchedTopics: Set<String>) { self.watchedTopics = watchedTopics }
    func save(favorites: [FavoriteArticle]) { self.favoriteTopics = favorites }
    func save(keyword: String) { self.keyword = keyword }
    func loadSettings(_ settings: [SettingsModel]) {}
}

private final class MockNetworkManager: NetworkManagerProtocol, @unchecked Sendable {
    var loadedCategory: String?
    var articlesToReturn: [Article] = []
    var shouldFail = false

    func loadNews(category: String) async throws -> [Article] {
        loadedCategory = category
        if shouldFail {
            throw ApiError.noConnection(msg: Errors.noConnection)
        }
        return articlesToReturn
    }
}

// MARK: - Tests
@MainActor
struct NewsUnitTests {
    // MARK: 1. MainViewModel Tests
    @Test("MainViewModel initializes with default state and binds managers")
    func testMainViewModelInit() {
        let soundManager = MockSoundManager()
        let vibrateManager = MockVibrateManager()
        let notificationManager = MockNotificationManager()
        let settingsManager = MockSettingsManager()
        let networkManager = MockNetworkManager()

        let viewModel = MainViewModel(
            soundManager: soundManager,
            vibrateManager: vibrateManager,
            notificationManager: notificationManager,
            settingsManager: settingsManager,
            networkManager: networkManager
        )

        #expect(viewModel.loadingState == .loading)
        #expect(viewModel.news.isEmpty)
    }

    @Test("MainViewModel loadNews invokes network manager with correct category")
    func testMainViewModelLoadNews() async {
        let networkManager = MockNetworkManager()
        let viewModel = MainViewModel(
            soundManager: MockSoundManager(),
            vibrateManager: MockVibrateManager(),
            notificationManager: MockNotificationManager(),
            settingsManager: MockSettingsManager(),
            networkManager: networkManager
        )

        viewModel.loadNews()
        try? await Task.sleep(for: .milliseconds(100))

        #expect(networkManager.loadedCategory == Constants.DefaultSettings.category)
    }

    @Test("MainViewModel shortcut handling toggles appropriate states")
    func testMainViewModelShortcutHandling() {
        let viewModel = MainViewModel(
            soundManager: MockSoundManager(),
            vibrateManager: MockVibrateManager(),
            notificationManager: MockNotificationManager(),
            settingsManager: MockSettingsManager(),
            networkManager: MockNetworkManager()
        )

        #expect(viewModel.settingsShortcutItemTapped == false)
        #expect(viewModel.shareShortcutItemTapped == false)

        viewModel.handleShortcutItemTap("settings")
        #expect(viewModel.settingsShortcutItemTapped == true)

        viewModel.handleShortcutItemTap("share")
        #expect(viewModel.shareShortcutItemTapped == true)
    }

    // MARK: 2. SettingsViewModel Tests
    @Test("SettingsViewModel applySettings updates setting for category, theme, loader, appIcon and language")
    func testSettingsViewModelApplySettings() {
        let settingsManager = MockSettingsManager()
        let networkManager = MockNetworkManager()

        let viewModel = SettingsViewModel(
            soundManager: MockSoundManager(),
            vibrateManager: MockVibrateManager(),
            notificationManager: MockNotificationManager(),
            settingsManager: settingsManager,
            networkManager: networkManager
        )

        viewModel.applySettings("business")
        #expect(settingsManager.category == "business")

        viewModel.applySettings("star wars")
        #expect(settingsManager.soundTheme == "star wars")

        viewModel.applySettings("rocket")
        #expect(settingsManager.loader == "rocket")

        viewModel.applySettings("globe")
        #expect(settingsManager.appIcon == "globe")

        viewModel.applySettings("ru")
        #expect(settingsManager.language == "ru")
        #expect(viewModel.currentLanguageItem == .russian)
    }

    // MARK: 3. Extensions & Helpers Tests
    @Test("String capitalizingFirstLetter capitalizes first letter correctly")
    func testStringCapitalizingFirstLetter() {
        #expect("hello".capitalizingFirstLetter() == "Hello")
        #expect("World".capitalizingFirstLetter() == "World")
        #expect("".capitalizingFirstLetter() == "")
    }

    @Test("Optional String or fallback provides correct non-nil value")
    func testOptionalExtensions() {
        let nilString: String? = nil
        let validString: String? = "news"

        #expect(nilString.or("default") == "default")
        #expect(validString.or("default") == "news")
        #expect(nilString.orEmpty == "")
    }

    // MARK: 4. Models & Enums Tests
    @Test("NewsCategory cases contain business, entertainment, technology")
    func testNewsCategoryEnum() {
        #expect(NewsCategory.allCases.contains(.business))
        #expect(NewsCategory.allCases.contains(.entertainment))
        #expect(NewsCategory.allCases.contains(.technology))
        #expect(!Texts.Category.title().isEmpty)
    }

    @Test("SoundTheme notification sound mapping")
    func testSoundThemeEnum() {
        #expect(SoundTheme.starwars.notificationSound == "starwars_notification")
        #expect(SoundTheme.cats.notificationSound == "cats_notification")
        #expect(SoundTheme.silentMode.notificationSound == "empty")
    }

    @Test("LoaderConfiguration shadow colors match expected styling")
    func testLoaderConfigurationEnum() {
        #expect(LoaderConfiguration.rocket.shadowColor == .orange)
    }

    @Test("AppIconConfiguration properties and names match")
    func testAppIconConfigurationEnum() {
        #expect(AppIconConfiguration.allCases.count == 3)
        #expect(!Texts.AppIcon.title().isEmpty)
        #expect(AppIconConfiguration.globe.iconName == "GlobeIcon")
    }

    @Test("ShortcutItem contains all configured shortcuts")
    func testShortcutItems() {
        #expect(ShortcutItem.allItems.count == 2)
        #expect(ShortcutItem.settings.rawValue == "settings")
        #expect(ShortcutItem.share.rawValue == "share")
    }

    @Test("AppLanguage enum contains English, Russian and Indonesian")
    func testAppLanguageEnum() {
        #expect(AppLanguage.allCases.count == 3)
        #expect(AppLanguage.english.rawValue == "en")
        #expect(AppLanguage.russian.rawValue == "ru")
        #expect(AppLanguage.indonesian.rawValue == "id")
        #expect(AppLanguage.english.flag == "🇬🇧")
        #expect(AppLanguage.russian.flag == "🇷🇺")
        #expect(AppLanguage.indonesian.flag == "🇮🇩")
    }

    @Test("Dynamic localization switches strings for en, ru, and id")
    func testDynamicLocalization() {
        Texts.currentLanguage = "en"
        #expect(Texts.Settings.language() == "Language")
        #expect(Texts.Category.business() == "Business")

        Texts.currentLanguage = "ru"
        #expect(Texts.Settings.language() == "Язык")
        #expect(Texts.Category.business() == "Бизнес")

        Texts.currentLanguage = "id"
        #expect(Texts.Settings.language() == "Bahasa")
        #expect(Texts.Category.business() == "Bisnis")

        Texts.currentLanguage = "en"
    }

    // MARK: 5. SettingsManager Tests
    @Test("SettingsManager provides default values and saves updates")
    func testSettingsManager() {
        let settingsManager = MockSettingsManager()
        #expect(settingsManager.category == Constants.DefaultSettings.category)
        #expect(settingsManager.language == Constants.DefaultSettings.language)

        settingsManager.save(category: "business")
        #expect(settingsManager.category == "business")

        settingsManager.save(language: "ru")
        #expect(settingsManager.language == "ru")
    }
}
