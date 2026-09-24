//
//  NewsWidgetsAttributes.swift
//  NewsWidgets
//
//  Created by Ярослав Куприянов on 05.04.2024.
//

import ActivityKit
import Foundation

public struct NewsWidgetsAttributes: ActivityAttributes, Sendable {
    public struct ContentState: Codable & Hashable, Sendable {
        public let level: Level
        public let procents: Int

        public init(level: Level, procents: Int) {
            self.level = level
            self.procents = procents
        }
    }

    public init() {}
}
