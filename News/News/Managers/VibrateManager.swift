//
//  VibrateManager.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import UIKit

protocol VibrateManagerProtocol: Sendable {
    @MainActor func vibrate(_ style: UIImpactFeedbackGenerator.FeedbackStyle)
    @MainActor func vibrate(_ type: UINotificationFeedbackGenerator.FeedbackType)
}

@MainActor
final class VibrateManager: VibrateManagerProtocol {
    private var impactGens: [UIImpactFeedbackGenerator.FeedbackStyle: UIImpactFeedbackGenerator]?
    private var notificationGen: UINotificationFeedbackGenerator?

    init() {
        prewarm()
    }

    func vibrate(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        impactGens?[style]?.impactOccurred(intensity: 0.4)
    }

    func vibrate(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        notificationGen?.notificationOccurred(type)
    }
}

// MARK: - Private
extension VibrateManager {
    fileprivate func prewarm() {
        let notificationGen = UINotificationFeedbackGenerator()
        notificationGen.prepare()
        self.notificationGen = notificationGen

        let light = UIImpactFeedbackGenerator(style: .light)
        let medium = UIImpactFeedbackGenerator(style: .medium)
        let soft = UIImpactFeedbackGenerator(style: .soft)
        let rigid = UIImpactFeedbackGenerator(style: .rigid)
        let heavy = UIImpactFeedbackGenerator(style: .heavy)

        impactGens = [
            .light: light,
            .heavy: heavy,
            .medium: medium,
            .soft: soft,
            .rigid: rigid,
        ]

        impactGens?.values.forEach { $0.prepare() }
    }
}
