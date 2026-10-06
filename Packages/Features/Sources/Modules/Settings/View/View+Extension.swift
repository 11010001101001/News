//
//  View+Extension.swift
//  Features
//
//  Created by Slava on 22.09.2026.
//

import DesignSystem
import SwiftUI

extension View {
    @ViewBuilder
    func markIsSelected(
        _ isSelected: Bool
    ) -> some View {
        self.modifier(PlasmaSelectionModifier(isSelected: isSelected))
    }
}
