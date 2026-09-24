//
//  SettingsModel.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation
import SwiftData

@Model
/// New params must be optional to avoid auto lightweight migration crash. Default value is also ok.
public final class SettingsModel {
    public var category: String
    public var soundTheme: String
    public var loader: String
    public var appIcon: String
    public var watchedTopics: Set<String> = []
    public var favoriteTopics: [FavoriteArticle] = []
    public var keyword: String = ""
    public var language: String? = DefaultSettings.language
    public var lastViewedTitle: String? = DefaultSettings.lastViewedTitle

    public init(
        category: String = DefaultSettings.category,
        soundTheme: String = DefaultSettings.soundTheme,
        loader: String = DefaultSettings.loader,
        appIcon: String = DefaultSettings.appIcon,
        language: String? = DefaultSettings.language
    ) {
        self.category = category
        self.soundTheme = soundTheme
        self.loader = loader
        self.appIcon = appIcon
        self.language = language
    }
}
