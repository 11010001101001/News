//
//  ViewModel+CheckIsRead.swift
//  News
//
//  Created by Ярослав Куприянов on 09.04.2024.
//

import Foundation
import UIKit

extension ViewModel {
    func checkIsRead(_ key: String) -> Bool {
        watchedTopics.contains(where: { $0 == key })
    }

    func markAsRead(_ key: String) {
        let isViewed = checkIsRead(key)

        guard !isViewed else { return }

        watchedTopics.append(key)
        clearStorageIfNeeded()
    }

	func markAsUnread(_ key: String) {
		watchedTopics.removeAll(where: { $0 == key })
		clearStorageIfNeeded()
	}

	func markAsReadOrUnread() {
		if isAllRead {
			newsArray.forEach { markAsUnread($0.key) }
		} else {
			newsArray.forEach { markAsRead($0.key) }
		}
	}

    private func clearStorageIfNeeded() {
        guard watchedTopics.count >= Constants.storageCapacity else { return }
        watchedTopics = Array(watchedTopics.dropFirst(Constants.needDropCount))
    }
}
