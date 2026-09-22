//
//  View+Extension.swift
//  Features
//
//  Created by Slava on 22.09.2026.
//

import SwiftUI
import DesignSystem

extension View {
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
}
