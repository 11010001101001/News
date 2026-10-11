//
//  File.swift
//  News
//
//  Created by Ярослав Куприянов on 11.10.2025.
//

import Foundation
import SwiftUI
import UIKit

public enum NavButtonType {
    case settings(isDefault: Bool)
    case markAsRead(isAllRead: Bool)
    case favorites(hasFavorites: Bool)
    case removeFavorites(hasFavorites: Bool)
    case close

    public var alignment: Alignment {
        switch self {
        case .settings: .leading
        case .close, .markAsRead, .favorites, .removeFavorites: .trailing
        }
    }

    public var imageName: String {
        let name: SFSymbols = switch self {
        case .settings(let isDefault):
            isDefault ? .gearshape : .gearshapeFill
        case .markAsRead(let isAllRead):
            isAllRead ? .checkmarkSealFill : .checkmarkSeal
        case .close: .chevronDown
        case .favorites(let hasFavorites):
            hasFavorites ? .heartFill : .heart
        case .removeFavorites(let hasFavorites):
            hasFavorites ? .trashFill : .trash
        }
        return name.rawValue
    }
}
