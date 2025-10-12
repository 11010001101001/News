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
    case close

    var alignment: Alignment {
        switch self {
        case .settings: .leading
        case .close, .markAsRead: .trailing
        }
    }

    var imageName: String {
        switch self {
        case let .settings(isDefault): isDefault ? "gearshape" : "gearshape.fill"
        case let .markAsRead(isAllRead): isAllRead ? "checkmark.seal.fill" : "checkmark.seal"
        case .close: "chevron.down"
        }
    }

    var rawValue: String {
        switch self {
        case .close: "close"
        case .markAsRead: "markAsRead"
        case .settings: "settings"
        }
    }
}
