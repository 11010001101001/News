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
final class SettingsModel {
    var category: String
    var soundTheme: String
    var loader: String
	var appIcon: String
    var watchedTopics: [String]?

    init(
		category: String = Constants.DefaultSettings.category,
		soundTheme: String = Constants.DefaultSettings.soundTheme,
		loader: String = Constants.DefaultSettings.loader,
		appIcon: String = Constants.DefaultSettings.appIcon
	) {
        self.category = category
        self.soundTheme = soundTheme
        self.loader = loader
		self.appIcon = appIcon
    }
}
