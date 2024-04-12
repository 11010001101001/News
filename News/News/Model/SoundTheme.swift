//
//  SoundTheme.swift
//  News
//
//  Created by Ярослав Куприянов on 28.03.2024.
//

import Foundation

enum SoundTheme: String, CaseIterable, Identifiable {
    var id: Self { return self }

    static var title: String { "Sound theme" }
    static var tabItemImage: String { "music.note.list" }

    case starwars = "star wars"
    case cats = "cats meow"
    case silentMode = "silent mode"
}
