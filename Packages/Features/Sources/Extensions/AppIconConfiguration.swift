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

extension AppIconConfiguration {
    static var tabImage: String { SFSymbols.photo.rawValue }
    
    public var shadowColor: Color {
        switch self {
        case .globe: .cyan
        case .cat: .orange
        case .dart: .red
        }
    }
}
