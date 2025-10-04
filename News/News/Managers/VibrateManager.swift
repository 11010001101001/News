//
//  VibrateManager.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import UIKit
import Combine

struct VibrateManager {
    private var impactCancellable: AnyCancellable?
    private var notificationCancellable: AnyCancellable?

    init(viewModel: MainViewModel) {
        let notificationGen = UINotificationFeedbackGenerator()
        notificationGen.prepare()

        let light = UIImpactFeedbackGenerator(style: .light)
        let medium = UIImpactFeedbackGenerator(style: .medium)
        let soft = UIImpactFeedbackGenerator(style: .soft)
        let rigid = UIImpactFeedbackGenerator(style: .rigid)
        let heavy = UIImpactFeedbackGenerator(style: .heavy)

        let impactGens: [UIImpactFeedbackGenerator.FeedbackStyle: UIImpactFeedbackGenerator] = [
            .light: light,
            .heavy: heavy,
            .medium: medium,
            .soft: soft,
            .rigid: rigid
        ]

        impactGens.values.forEach { $0.prepare() }

        func bind() {
            impactCancellable = viewModel.$feedbackStyle
                .sink { style in
                    guard let style else { return }
                    impactGens[style]?.impactOccurred(intensity: 0.4)
                }

            notificationCancellable = viewModel.$feedBackType
                .sink { type in
                    guard let type else { return }
                    notificationGen.notificationOccurred(type)
                }
        }

        bind()
    }
}
