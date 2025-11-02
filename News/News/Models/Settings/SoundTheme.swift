//
//  SoundTheme.swift
//  News
//
//  Created by Ярослав Куприянов on 28.03.2024.
//

import Foundation

enum SoundTheme: String, CaseIterable, Identifiable {
    var id: Self { return self }

    static var title: String { "Sound" }

    static var image: String { SFSymbols.musicNote.rawValue }

    case starwars = "star wars"
    case cats = "cats meow"
    case silentMode = "silent mode"

    var notificationSound: String {
        switch self {
        case .starwars:
            "starwars_notification"
        case .cats:
            "cats_notification"
        case .silentMode:
            "empty"
        }
    }
}
