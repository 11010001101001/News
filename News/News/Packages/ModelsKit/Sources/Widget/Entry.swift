//
//  Entry.swift
//  NewsWidgetsExtension
//
//  Created by Ярослав Куприянов on 29.10.2025.
//

import Foundation
import WidgetKit

public struct Entry: TimelineEntry {
    public var date: Date

    public let category: String
    public let level: Level

    public init(category: String, level: Level) {
        self.date = Date()
        self.level = level
        self.category = category.capitalized
    }
}
