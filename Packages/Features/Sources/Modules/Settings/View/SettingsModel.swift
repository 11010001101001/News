//
//  SettingsModel.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation
import SwiftData
import DesignSystem
import ModelsKit

@Model
public final class SettingsModel {
    public var category = NewsCategory.business
    public var soundTheme = SoundTheme.silentMode
    public var loader = ShaderLoaderType.auroraBorealis
    public var appIcon = AppIconConfiguration.globe
    public var watchedTopics = Set<String>()
    public var favoriteTopics = [Article]()
    public var keyword = String.empty
    public var language = AppLanguage.english
    public var lastViewedTitle = String.dots

    public init() {}
}
