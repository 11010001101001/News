//
//  NotificationManager.swift
//  News
//
//  Created by Ярослав Куприянов on 09.04.2024.
//

import Foundation
import Combine
import UIKit

protocol NotificationManagerProtocol {
    func bind(to publisher: AnyPublisher<String, Never>)
}

final class NotificationManager {
    private var cancellables = Set<AnyCancellable>()
}

// MARK: - NotificationManagerProtocol
extension NotificationManager: NotificationManagerProtocol {
    func bind(to publisher: AnyPublisher<String, Never>) {
        publisher
            .sink { [weak self] sound in
                self?.configureNotifications(with: sound)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private
private extension NotificationManager {
    func configureNotifications(with sound: String) {
        let notificationCenter = UNUserNotificationCenter.current()

        notificationCenter.removeAllPendingNotificationRequests()

        notificationCenter.getPendingNotificationRequests { requests in
            guard requests.isEmpty else { return }

            let options: UNAuthorizationOptions = [.alert, .badge, .carPlay, .providesAppNotificationSettings, .sound]

            notificationCenter.requestAuthorization(options: options) { granted, error in
                guard error == nil, granted else { return }

                let content = UNMutableNotificationContent()
                content.title = Texts.Notification.title()
                content.body = Texts.Notification.body()
                content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(sound).mp3"))

                var dateComponents = DateComponents()
                dateComponents.weekday = 6
                dateComponents.hour = 17

                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

                let uuid = UUID().uuidString

                let request = UNNotificationRequest(
                    identifier: uuid,
                    content: content,
                    trigger: trigger
                )

                notificationCenter.add(request)
            }
        }
    }
}
