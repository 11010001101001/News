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
    case favorites(isEmpty: Bool)
    case close

    var alignment: Alignment {
        switch self {
        case .settings: .leading
        case .close, .markAsRead, .favorites: .trailing
        }
    }

    var imageName: String {
        switch self {
        case let .settings(isDefault): isDefault ? "gearshape" : "gearshape.fill"
        case let .markAsRead(isAllRead): isAllRead ? "checkmark.seal.fill" : "checkmark.seal"
        case .close: "chevron.down"
        case let .favorites(hasFavorites): hasFavorites ? SFSymbols.starFill.rawValue : SFSymbols.star.rawValue 
        }
    }
}
