//
//  Delegates.swift
//  News
//
//  Created by Ярослав Куприянов on 11.04.2024.
//

import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
	override init() {
		super.init()
		setURLCacheMemoryCapacity()
	}

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if let selectedAction = options.shortcutItem {
            ShortcutItem.selectedAction = selectedAction
        }
        let configuration = UISceneConfiguration(name: "scene", sessionRole: connectingSceneSession.role)
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    func windowScene(_ windowScene: UIWindowScene,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        ShortcutItem.selectedAction = shortcutItem
    }
}

extension AppDelegate {
	func setURLCacheMemoryCapacity() {
		// ~200 MB memory space
		URLCache.shared.memoryCapacity = 200_000_000
		// ~1GB disk cache space
		URLCache.shared.diskCapacity = 1_000_000_000
	}
}
