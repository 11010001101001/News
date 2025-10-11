//
//  VibrateManager.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import UIKit
import Combine

protocol VibrateManagerProtocol {
    func bind(to publisher: AnyPublisher<UIImpactFeedbackGenerator.FeedbackStyle?, Never>)
    func bind(to publisher: AnyPublisher<UINotificationFeedbackGenerator.FeedbackType?, Never>)
}

final class VibrateManager {
    private var cancellables = Set<AnyCancellable>()
    private var impactGens: [UIImpactFeedbackGenerator.FeedbackStyle: UIImpactFeedbackGenerator]?
    private var notificationGen: UINotificationFeedbackGenerator?

    init() { prewarm() }
}

// MARK: - VibrateManagerProtocol
extension VibrateManager: VibrateManagerProtocol {
    func bind(to publisher: AnyPublisher<UIImpactFeedbackGenerator.FeedbackStyle?, Never>) {
        publisher
            .sink { [weak self] style in
                guard let style else { return }
                self?.impactGens?[style]?.impactOccurred(intensity: 0.4)
            }
            .store(in: &cancellables)
    }

    func bind(to publisher: AnyPublisher<UINotificationFeedbackGenerator.FeedbackType?, Never>) {
        publisher
            .sink { [weak self] type in
                guard let type else { return }
                self?.notificationGen?.notificationOccurred(type)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private
extension VibrateManager {
    func prewarm() {
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
            .rigid: rigid
        ]

        impactGens?.values.forEach { $0.prepare() }
    }
}
