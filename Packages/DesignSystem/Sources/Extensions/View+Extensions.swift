//
//  View+Extensions.swift
//  News
//
//  Created by Ярослав Куприянов on 27.03.2024.
//

import Foundation
import SwiftUI

extension View {
    /// more glassy
    public func glassClearInteractive() -> some View {
        self
            .glassEffect(
                .clear.interactive(), in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }

    /// less glassy
    public func glassRegularInteractive() -> some View {
        self
            .glassEffect(
                .regular.interactive(), in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }

    public func glassEffectRegular() -> some View {
        self
            .glassEffect(.regular)
    }

    @ViewBuilder
    public func applyOrNotSettingsModifier(
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
    public func markAsReadOrHighlight(
        isRead: Bool,
        isShadowEnabled: Bool
    ) -> some View {
        self
            .modifier(PlasmaSelectionModifier(isSelected: isShadowEnabled && !isRead))
            .opacity(isRead ? 0.5 : 1.0)
    }
}
