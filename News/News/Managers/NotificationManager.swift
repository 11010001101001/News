//
//  NotificationManager.swift
//  News
//
//  Created by Ярослав Куприянов on 09.04.2024.
//

import Foundation
import UserNotifications

protocol NotificationManagerProtocol: Sendable {
    func configureNotifications(with sound: String) async
}

final class NotificationManager: NotificationManagerProtocol, Sendable {
    func configureNotifications(with sound: String) async {
        guard SoundTheme.allCases.map({ $0.notificationSound }).contains(sound) else { return }

        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()

        let pending = await notificationCenter.pendingNotificationRequests()
        guard pending.isEmpty else { return }

        let options: UNAuthorizationOptions = [
            .alert, .badge, .carPlay, .providesAppNotificationSettings, .sound,
        ]

        do {
            let granted = try await notificationCenter.requestAuthorization(options: options)
            guard granted else { return }

            let content = UNMutableNotificationContent()
            content.title = String(localized: .notificationTitle)
            content.body = String(localized: .notificationBody)
            content.sound = UNNotificationSound(
                named: UNNotificationSoundName(rawValue: "\(sound).mp3"))

            var dateComponents = DateComponents()
            dateComponents.weekday = 6
            dateComponents.hour = 17

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let uuid = UUID().uuidString
            let request = UNNotificationRequest(
                identifier: uuid, content: content, trigger: trigger)

            try await notificationCenter.add(request)
        } catch {
            print("Notification configuration error: \(error.localizedDescription)")
        }
    }
}
