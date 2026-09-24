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
    public let category: LocalizedStringResource
    public let level: Level
    public let procentsToNextLevel: Int
    public let lastViewedTitle: String

    public init(category: LocalizedStringResource, level: Level, procentsToNextLevel: Int, lastViewedTitle: String) {
        self.date = Date()
        self.level = level
        self.category = category
        self.procentsToNextLevel = procentsToNextLevel
        self.lastViewedTitle = lastViewedTitle
    }
}
