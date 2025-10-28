//
//  File.swift
//  News
//
//  Created by Ярослав Куприянов on 11.10.2025.
//

import Foundation
import UIKit
import SwiftUI

enum NavButtonType {
    case settings(isDefault: Bool)
    case markAsRead(isAllRead: Bool)
    case favorites(hasFavorites: Bool)
    case removeFavorites(hasFavorites: Bool)
    case close

    var alignment: Alignment {
        switch self {
        case .settings: .leading
        case .close, .markAsRead, .favorites, .removeFavorites: .trailing
        }
    }

    var imageName: String {
        switch self {
        case let .settings(isDefault): isDefault ? SFSymbols.gearshape.rawValue : SFSymbols.gearshapeFill.rawValue
        case let .markAsRead(isAllRead): isAllRead ? SFSymbols.checkmarkSealFill.rawValue : SFSymbols.checkmarkSeal.rawValue
        case .close: SFSymbols.chevronDown.rawValue
        case let .favorites(hasFavorites): hasFavorites ? SFSymbols.heartFill.rawValue : SFSymbols.heart.rawValue
        case let .removeFavorites(hasFavorites): hasFavorites ? SFSymbols.trashFill.rawValue : SFSymbols.trash.rawValue
        }
    }
}
