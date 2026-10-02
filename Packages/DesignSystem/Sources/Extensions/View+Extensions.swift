//
//  View+Extensions.swift
//  News
//
//  Created by Ярослав Куприянов on 27.03.2024.
//

import Foundation
import SwiftUI

public extension View {
    /// more glassy
    func glassClearInteractive() -> some View {
        self
            .glassEffect(
                .clear.interactive(), in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }

    /// less glassy
    func glassRegularInteractive() -> some View {
        self
            .glassEffect(
                .regular.interactive(), in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }

    func glassEffectRegular() -> some View {
        self
            .glassEffect(.regular)
    }

    @ViewBuilder
    func applyOrNotSettingsModifier(
        isEnabled: Bool,
        execute: @escaping () -> Void
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
                self.modifier(PlasmaSelectionModifier())
            } else {
                self
            }
        }
    }
}
