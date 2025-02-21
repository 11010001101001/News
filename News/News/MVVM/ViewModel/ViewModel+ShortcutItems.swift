//
//  ViewModel+ShortcutItems.swift
//  News
//
//  Created by Ярослав Куприянов on 11.04.2024.
//

import Foundation
import UIKit

extension ViewModel {
    func addShortcutItems() {
        UIApplication.shared.shortcutItems = ShortcutItem.allItems
    }

    func handleShortcutItemTap(_ name: String) {
        switch name {
        case ShortcutItem.settings.rawValue:
            settingsShortcutItemTapped.toggle()
        case ShortcutItem.share.rawValue:
            shareShortcutItemTapped.toggle()
        default:
            break
        }
    }
}
