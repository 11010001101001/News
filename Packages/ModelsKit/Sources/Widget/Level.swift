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
        case (0..<25): .newbie
        case (25..<75): .curiousObserver
        case (75..<100): .loopMaster
        case (100...): .techNinja
        default: .newbie
        }
    }

    public func progressInLevel(for procents: Int) -> Int {
        let minMaxDiff = maxLevelProcent() - minLevelProcent()
        guard minMaxDiff > 0 else { return 100 }
        let progress = (procents - minLevelProcent()) * 100 / minMaxDiff
        return min(max(progress, 0), 100)
    }

    public func maxLevelProcent() -> Int {
        switch self {
        case .techNinja: 100
        case .loopMaster: 99
        case .curiousObserver: 74
        case .newbie: 24
        }
    }

    public func minLevelProcent() -> Int {
        switch self {
        case .techNinja: 100
        case .loopMaster: 75
        case .curiousObserver: 25
        case .newbie: 0
        }
    }
}
