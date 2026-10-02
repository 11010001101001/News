//
//  PlasmaSelectionProvider.swift
//
//  Created by Slava & Gemini
//  Custom Metal FBM Domain-Warping Plasma Shader.
//

import SwiftUI

public struct PlasmaSelectionModifier: ViewModifier {
    private let packageShaders = ShaderLibrary.bundle(.module)

    public init() {}

    public func body(content: Content) -> some View {
        content
            .overlay {
                TimelineView(.animation) { context in
                    let time = Float(
                        context.date.timeIntervalSince1970.truncatingRemainder(dividingBy: 1000)
                    )

                    Rectangle()
                        .fill(.red.opacity(0.01))
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
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
}
