//
//  File.swift
//  ModelsKit
//
//  Created by Slava on 29.09.2026.
//

import SwiftUI

public enum Rating: String, Sendable {
    case cool = "COOL"
    case whoCares = "WHO CARES"
    case sucks = "SUCKS"
    case loading
    case error = "🖕"
    case cooling = "COOLING"
    case lowPower = "LOW POWER"

    public var iconName: String {
        switch self {
        case .cool: "flame.fill"
        case .whoCares: "face.dashed"
        case .sucks: "hand.thumbsdown.fill"
        case .loading: "sparkles"
        case .error: "slash.circle"
        case .cooling: "snowflake"
        case .lowPower: "battery.25"
        }
    }

    public var color: Color {
        switch self {
        case .cool: .green
        case .whoCares: .yellow
        case .sucks: .red
        case .loading: .white
        case .error: .gray
        case .cooling: .cyan
        case .lowPower: .yellow
        }
    }

    public static var validRatings: [Rating] {
        [.cool, .whoCares, .sucks]
    }
}
