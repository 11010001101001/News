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

extension NewsCategory {
    static var tabImage: String { SFSymbols.listBullet.rawValue }

    public var image: SFSymbols {
        switch self {
        case .business: .brainFilledHeadProfile
        case .entertainment: .play
        case .general: .listClipboard
        case .health: .boltHeart
        case .science: .atom
        case .sports: .figureOutdoorCycle
        case .technology: .iphoneGen1RadiowavesLeftAndRight
        }
    }
}
