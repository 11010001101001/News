//
//  ViewModel+Haptics.swift
//  News
//
//  Created by Ярослав Куприянов on 01.04.2024.
//

import Foundation
import UIKit

extension ViewModel {
    func impactOccured(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        feedbackStyle = style
    }

    func notificationOccurred(_ feedBackType: UINotificationFeedbackGenerator.FeedbackType) {
        self.feedBackType = feedBackType
    }
}
