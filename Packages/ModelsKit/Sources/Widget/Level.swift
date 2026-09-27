//
//  Level.swift
//  News
//
//  Created by Ярослав Куприянов on 29.10.2025.
//

import Foundation
import LocalizationKit
import SwiftUI

public enum Level: Sendable {
    case techNinja
    case insider
    case observer
    case newbie

    public static var allCases: [Level] {
        [.newbie, .observer, .insider, .techNinja]
    }

    public var name: LocalizedStringResource {
        switch self {
        case .techNinja: Strings.levelNinja
        case .insider: Strings.levelInsider
        case .observer: Strings.levelObserver
        case .newbie: Strings.levelNewbie
        }
    }

    public var color: Color {
        switch self {
        case .techNinja: .indigo
        case .insider: .cyan
        case .observer: .green
        case .newbie: .orange
        }
    }

    public var image: String {
        switch self {
        case .techNinja: "🥷🏿"
        case .insider: "👨🏽‍🎓"
        case .observer: "💁🏻‍♂️"
        case .newbie: "👶🏻"
        }
    }

    public var range: String {
        switch self {
        case .techNinja: "75% - 100%"
        case .insider: "50% - 75%"
        case .observer: "25% - 50%"
        case .newbie: "0% - 25%"
        }
    }
}

extension Level: Codable {}

extension Level {
    public static func getLevel(for procents: Int) -> Level {
        switch procents {
        case (..<25): .newbie
        case (25..<50): .observer
        case (50..<75): .insider
        case (75...): .techNinja
        default: .newbie
        }
    }

    public func progressInLevel(for procents: Int) -> Int {
        let levelStep = 25
        let progress = (procents - minLevelProcent()) * 100 / levelStep
        return min(max(progress, 0), 100)
    }

    public func minLevelProcent() -> Int {
        switch self {
        case .techNinja: 75
        case .insider: 50
        case .observer: 25
        case .newbie: 0
        }
    }

    public static func visualProgress(for procents: Int) -> Float {
        switch procents {
        case 0..<25: Float(procents) / 25.0 * 0.333
        case 25..<50: 0.333 + Float(procents - 25) / 25.0 * 0.333
        case 50..<75: 0.666 + Float(procents - 50) / 25.0 * 0.334
        default: 1.0
        }
    }
}
