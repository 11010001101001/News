//
//  Level.swift
//  News
//
//  Created by Ярослав Куприянов on 29.10.2025.
//

import Foundation
import SwiftUI

public enum Level: String, Sendable {
    case techNinja = "Tech Ninja"
    case loopMaster = "Loop Master"
    case curiousObserver = "Observer"
    case newbie = "Newbie"
    case error
    case unrecognized

    public var color: Color {
        switch self {
        case .techNinja: .indigo
        case .loopMaster: .cyan
        case .curiousObserver: .green
        case .newbie: .orange
        case .error: .red
        case .unrecognized: .red
        }
    }

    public var image: String {
        switch self {
        case .techNinja: "🥷🏿"
        case .loopMaster: "👨🏽‍🎓"
        case .curiousObserver: "💁🏻‍♂️"
        case .newbie: "👶🏻"
        case .error: "🚫"
        case .unrecognized: "⁉️"
        }
    }

    public var range: String {
        switch self {
        case .techNinja: "75% - 100%"
        case .loopMaster: "50% - 75%"
        case .curiousObserver: "25% - 50%"
        case .newbie: "0% - 25%"
        case .error: .empty
        case .unrecognized: .empty
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
        default: .unrecognized
        }
    }
}
