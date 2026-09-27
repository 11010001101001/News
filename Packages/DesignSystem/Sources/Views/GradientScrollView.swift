//
//  GradientScrollView.swift
//  DesignSystem
//
//  Created by Slava on 27.09.2026.
//

import SwiftUI

public struct GradientScrollView<T: View>: View {
    let content: () -> T

    public init (@ViewBuilder content: @escaping () -> T) {
        self.content = content
    }

    public var body: some View {
        ZStack {
            ScrollView {
                content()
            }
            gradient
        }
    }

    private var gradient: some View {
        VerStack {
            Spacer()
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: Constants.gradientHeight)
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}
