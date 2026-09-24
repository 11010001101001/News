//
//  File.swift
//  Features
//
//  Created by Slava on 22.09.2026.
//

import Foundation
import ModelsKit
import DesignSystem
import SwiftUI

extension LoaderConfiguration {
    static var tabImage: String { SFSymbols.hourglass.rawValue }

    public var shadowColor: Color {
        switch self {
        case .rocket: .orange
        case .hourGlass: .cyan
        case .astronaut: .red
        case .hamster: .blue
        case .kitten: .indigo
        }
    }
}
