//
//  File.swift
//  ModelsKit
//
//  Created by Slava on 29.09.2026.
//

import SwiftUI

public enum Rating: String, CaseIterable, Sendable {
    case cool = "COOL"
    case whoCares = "WHO CARES"
    case sucks = "SUCKS"
    case loading

    public var iconName: String {
        switch self {
        case .cool: "flame.fill"
        case .whoCares: "face.dashed"
        case .sucks: "hand.thumbsdown.fill"
        case .loading: "sparkles"
        }
    }

    public var color: Color {
        switch self {
        case .cool: .green
        case .whoCares: .gray
        case .sucks: .red
        case .loading: .white
        }
    }
}
