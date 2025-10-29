//
//  Entry.swift
//  NewsWidgetsExtension
//
//  Created by Ярослав Куприянов on 29.10.2025.
//

import Foundation
import WidgetKit

struct Entry: TimelineEntry {
    var date: Date

    let category: String
    let level: Level

    init(category: String, level: Level) {
        self.date = Date()
        self.level = level
        self.category = category.capitalized
    }
}
