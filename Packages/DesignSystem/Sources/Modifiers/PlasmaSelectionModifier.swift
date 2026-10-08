//
//  PlasmaSelectionProvider.swift
//
//  Created by Slava & Gemini
//  Custom Metal FBM Domain-Warping Plasma Shader.
//

import SwiftUI

public struct PlasmaSelectionModifier: ViewModifier {
    private let packageShaders = ShaderLibrary.bundle(.module)
    private let isSelected: Bool

    @State private var isAnimating = false

    public init(isSelected: Bool) {
        self.isSelected = isSelected
    }

    public func body(content: Content) -> some View {
        content
            .overlay {
                timelineView
                    .scaleEffect(y: isAnimating ? 1.0 : 0.2, anchor: .bottom)
                    .opacity(isAnimating ? 1 : 0)
            }
            .onAppear {
                withAnimation(.snappy(duration: 0.25, extraBounce: 0.15)) {
                    isAnimating = isSelected
                }
            }
    }

    private var timelineView: some View {
        TimelineView(.animation) { context in
            let time = Float(
                context.date.timeIntervalSince1970.truncatingRemainder(dividingBy: 1000)
            )

            Rectangle()
                .fill(.black.opacity(0.01))
                .visualEffect { viewContent, proxy in
                    viewContent.layerEffect(
                        packageShaders.liquidGlassLens(
                            .float(time),
                            .float2(proxy.size),
                            .float(Constants.cornerRadius)
                        ),
                        maxSampleOffset: CGSize(width: 16, height: 16)
                    )
                }
                .allowsHitTesting(false)
        }
    }
}
