//
//  View+Extensions.swift
//  News
//
//  Created by Ярослав Куприянов on 27.03.2024.
//

import Foundation
import SwiftUI

extension View {
    func glassCard() -> some View {
        self
            .glassEffect(
                .clear.interactive(), in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }

    func glassRegularCard() -> some View {
        self
            .glassEffect(
                .regular.interactive(), in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }

    @ViewBuilder
    func applyOrNotSettingsModifier(
        isEnabled: Bool,
        execute: Action
    ) -> some View {
        if isEnabled {
            self.modifier(AnswerNegative(execute: execute))
        } else {
            self.modifier(OnTap(execute: nil, completion: execute))
        }
    }

    @ViewBuilder
    func markAsReadOrHighlight(
        isRead: Bool,
        isShadowEnabled: Bool
    ) -> some View {
        let opacity = isRead ? 0.5 : 1.0

        switch (isRead, isShadowEnabled) {
        case (false, false):
            self
        case (true, false), (true, true):
            self.opacity(opacity)
        case (false, true):
            if isShadowEnabled {
                self.modifier(InnerShadowProvider())
            } else {
                self
            }
        }
    }

    @ViewBuilder
    func markIsSelected(
        _ viewModel: SettingsViewModel,
        _ id: String
    ) -> some View {
        if viewModel.checkIsEnabled(id.lowercased()) {
            self.modifier(InnerShadowProvider())
        } else {
            self
        }
    }

    @ViewBuilder
    func gloss(
        isEnabled: Bool = true,
        color: Color = .shadowHighlight,
        radius: CGFloat = 10.0,
        numberOfLayers: Int = 4,
        isBorderHighlighted: Bool = false
    ) -> some View {
        if isEnabled {
            self
                .overlay {
                    ZStack {
                        ForEach(0..<numberOfLayers, id: \.self) { _ in
                            self
                                .shadow(
                                    color: color,
                                    radius: radius
                                )
                        }

                        ConditionalView(isBorderHighlighted) {
                            ForEach(0..<5) { _ in
                                self
                                    .shadow(
                                        color: .white,
                                        radius: 2
                                    )
                            }
                        }
                    }
                }
        } else {
            self
        }
    }
}
