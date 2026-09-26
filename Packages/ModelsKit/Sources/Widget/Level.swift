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
    case loopMaster
    case curiousObserver
    case newbie

    public static var allCases: [Level] {
        [.newbie, .curiousObserver, .loopMaster, .techNinja]
    }

    public var name: LocalizedStringResource {
        switch self {
        case .techNinja: Strings.levelNinja
        case .loopMaster: Strings.levelLoopMaster
        case .curiousObserver: Strings.levelObserver
        case .newbie: Strings.levelNewbie
        }
    }

    public var color: Color {
        switch self {
        case .techNinja: .indigo
        case .loopMaster: .cyan
        case .curiousObserver: .green
        case .newbie: .orange
        }
    }

    public var image: String {
        switch self {
        case .techNinja: "🥷🏿"
        case .loopMaster: "👨🏽‍🎓"
        case .curiousObserver: "💁🏻‍♂️"
        case .newbie: "👶🏻"
        }
    }

    public var range: String {
        switch self {
        case .techNinja: "75% - 100%"
        case .loopMaster: "50% - 75%"
        case .curiousObserver: "25% - 50%"
        case .newbie: "0% - 25%"
        }
    }
}

extension Level: Codable {}

extension Level {
    public static func getLevel(for procents: Int) -> Level {
        switch procents {
        case (..<25): .newbie
        case (25..<50): .curiousObserver
        case (50..<75): .loopMaster
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
        case .loopMaster: 50
        case .curiousObserver: 25
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
