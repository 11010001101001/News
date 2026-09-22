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

extension SoundTheme {
    static var tabImage: String { SFSymbols.musicNote.rawValue }
    
    public var image: Image {
        let systemName: SFSymbols =
            switch self {
            case .starwars: .starFill
            case .silentMode: .powersleep
            case .cats: .catFill
            }
        return Image(systemName: systemName.rawValue)
    }
}
