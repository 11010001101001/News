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
        switch self {
        case .settings(let isDefault):
            isDefault ? SFSymbols.gearshape.rawValue : SFSymbols.gearshapeFill.rawValue
        case .markAsRead(let isAllRead):
            isAllRead ? SFSymbols.checkmarkSealFill.rawValue : SFSymbols.checkmarkSeal.rawValue
        case .close: SFSymbols.chevronDown.rawValue
        case .favorites(let hasFavorites):
            hasFavorites ? SFSymbols.heartFill.rawValue : SFSymbols.heart.rawValue
        case .removeFavorites(let hasFavorites):
            hasFavorites ? SFSymbols.trashFill.rawValue : SFSymbols.trash.rawValue
        }
    }
}
