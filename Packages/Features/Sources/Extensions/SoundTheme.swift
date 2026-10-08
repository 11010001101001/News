//
//  File.swift
//  Features
//
//  Created by Slava on 22.09.2026.
//

import DesignSystem
import Foundation
import ModelsKit
import SwiftUI

extension SoundTheme {
    static var tabImage: String { SFSymbols.musicNote.rawValue }

    public var image: SFSymbols {
        switch self {
        case .starwars: .starFill
        case .silentMode: .powersleep
        case .cats: .catFill
        }
    }
}
