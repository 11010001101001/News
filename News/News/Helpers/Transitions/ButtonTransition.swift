//
//  ButtonTransition.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 16.02.2025.
//

import SwiftUI

struct ButtonTransition: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .opacity(phase.isIdentity ? 1 : 0.001)
            .brightness(phase == .willAppear ? 1 : 0)
    }
}
