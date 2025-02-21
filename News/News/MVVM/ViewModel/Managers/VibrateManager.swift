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

    init(viewModel: ViewModel) {
        func bind() {
            impactCancellable = viewModel.$feedbackStyle
                .sink { style in
                    guard let style else { return }
                    UIImpactFeedbackGenerator().prepare()
                    UIImpactFeedbackGenerator(style: style).impactOccurred()
                }

            notificationCancellable = viewModel.$feedBackType
                .sink { type in
                    guard let type else { return }
                    UINotificationFeedbackGenerator().prepare()
                    UINotificationFeedbackGenerator().notificationOccurred(type)
                }
        }

        bind()
    }
}
