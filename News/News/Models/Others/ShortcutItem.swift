//
//  ShortcutItem.swift
//  News
//
//  Created by Ярослав Куприянов on 11.04.2024.
//

import UIKit

enum ShortcutItem: String {
    static var selectedAction: UIApplicationShortcutItem?

    static var shareInfo: [String: NSSecureCoding] {
        ["name": ShortcutItem.share.rawValue as NSSecureCoding]
    }

    static var settingsInfo: [String: NSSecureCoding] {
        ["name": ShortcutItem.settings.rawValue as NSSecureCoding]
    }

    static var allItems = [
        UIMutableApplicationShortcutItem(type: ShortcutItem.share.rawValue,
                                         localizedTitle: ShortcutItem.share.title,
                                         localizedSubtitle: nil,
                                         icon: UIApplicationShortcutIcon(
                                            systemImageName: ShortcutItem.share.systemImageName),
                                         userInfo: shareInfo),
        UIMutableApplicationShortcutItem(type: ShortcutItem.settings.rawValue,
                                         localizedTitle: ShortcutItem.settings.title,
                                         localizedSubtitle: nil,
                                         icon: UIApplicationShortcutIcon(
                                            systemImageName: ShortcutItem.settings.systemImageName),
                                         userInfo: settingsInfo)
    ]

    case settings
    case share

	var title: String {
		switch self {
		case .settings: "Open settings"
		case .share: "Share app"
		}
	}

	var systemImageName: String {
		switch self {
		case .settings: "gear"
		case .share: "square.and.arrow.up"
		}
	}
}
