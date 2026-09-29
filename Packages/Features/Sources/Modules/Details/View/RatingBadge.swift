//
//  RatingBadge.swift
//  DesignSystem
//
//  Created by Slava on 29.09.2026.
//

import DesignSystem
import ModelsKit
import SwiftUI

struct RatingBadge: View {
    let rating: Rating
    @State private var isPulsing = false

    var body: some View {
        if rating == .loading {
            loader
        } else {
            state
                .transition(.blurReplace.combined(with: .opacity))
        }
    }

    var loader: some View {
        HorStack {
            Circle()
                .fill(rating.color)
                .frame(width: 8, height: 8)
                .shadow(color: rating.color.opacity(0.8), radius: 4)
                .scaleEffect(isPulsing ? 1.2 : 0.85)
                .opacity(isPulsing ? 1.0 : 0.5)
                .onAppear {
                    withAnimation(
                        .easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true)
                    ) {
                        isPulsing = true
                    }
                }
            Spacer()
        }
    }

    var state: some View {
        HorStack(spacing: 5) {
            Image(systemName: rating.iconName)
                .font(.system(size: 10, weight: .bold))
            Text(rating.rawValue)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .foregroundColor(rating.color)
        .background(
            Capsule()
                .fill(rating.color.opacity(0.15))
                .background(.ultraThinMaterial, in: Capsule())
        )
        .overlay(
            Capsule()
                .stroke(rating.color.opacity(0.35), lineWidth: 1)
        )
    }
}
