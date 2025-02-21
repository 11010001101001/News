//
//  ViewModel.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation
import Combine
import SwiftUI
import SwiftData

final class ViewModel: Observable, ObservableObject {
    @Published var newsArray = [Article]()
    @Published var loadingSucceed = false
    @Published var loadingFailed = false
    @Published var failureReason = String.empty
    /// For redraw loader on content view after settings loaded: render loader -> settings loaded -> redraw
    @Published var id: Int?
    @Published var keyWord: String?

    @Published var errorSound = String.empty
    @Published var refreshSound = String.empty
    @Published var loadedSound = String.empty
    @Published var notificationSound = String.empty

    @Published var feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle?
    @Published var feedBackType: UINotificationFeedbackGenerator.FeedbackType?

    @Published var settingsShortcutItemTapped = false
    @Published var shareShortcutItemTapped = false

    @Published var imageCacheData: (image: AnyObject, key: AnyObject)?

    @Published var cancellables = Set<AnyCancellable>()

    var soundManager: SoundManager?
    var vibrateManager: VibrateManager?
    var notificationManager: NotificationManager?
    var cacheManager: CacheManager?

	var savedSettings: [SettingsModel]?

	var loaderShadowColor: Color {
		LoaderConfiguration(rawValue: loader)?.shadowColor ?? .clear
	}

	var isAllRead: Bool {
		guard !newsArray.isEmpty else { return false }
		return newsArray.allSatisfy { checkIsRead($0.key) }
	}

	var isDefaultSettings: Bool {
		category == Constants.DefaultSettings.category &&
		soundTheme == Constants.DefaultSettings.soundTheme &&
		loader == Constants.DefaultSettings.loader &&
		appIcon == Constants.DefaultSettings.appIcon
	}

    init() {
        soundManager = SoundManager(viewModel: self)
        vibrateManager = VibrateManager(viewModel: self)
        notificationManager = NotificationManager(viewModel: self)
        cacheManager = CacheManager(viewModel: self)
    }

    deinit {
        soundManager = nil
        vibrateManager = nil
        notificationManager = nil
        cacheManager = nil
        cancellables.forEach { $0.cancel() }
    }
}
