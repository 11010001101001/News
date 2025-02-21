//
//  ViewModel+Notifications.swift
//  News
//
//  Created by Ярослав Куприянов on 09.04.2024.
//

import Foundation

extension ViewModel {
    /// sound theme can change - do it during every app launch and sound changing
    func configureNotifications() {
        notificationSound = switch SoundTheme(rawValue: soundTheme) {
        case .starwars:
            "starwars_notification"
        case .cats:
            "cats_notification"
        default:
            String.empty
        }
    }
}
