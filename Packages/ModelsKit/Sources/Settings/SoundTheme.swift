//
//  SoundTheme.swift
//  News
//
//  Created by Ярослав Куприянов on 28.03.2024.
//

import SwiftUI
import CoreKit
import LocalizationKit

public enum SoundTheme: String, CaseIterable, Identifiable, DisplayName {
    public var id: Self { return self }

    case starwars = "star wars"
    case cats = "cats meow"
    case silentMode = "silent mode"

    public var notificationSound: String {
        switch self {
        case .starwars:
            "starwars_notification"
        case .cats:
            "cats_notification"
        case .silentMode:
            "empty"
        }
    }

    public var displayName: LocalizedStringResource {
        switch self {
        case .starwars: Strings.soundStarwars
        case .cats: Strings.soundCats
        case .silentMode: Strings.soundSilentMode
        }
    }
}
