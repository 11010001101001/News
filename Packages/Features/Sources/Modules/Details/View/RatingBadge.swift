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
    let viewModel: DetailsViewModel

    @State private var rating: Rating = .loading

    var body: some View {
        content
            .frame(height: 16)
            .task(id: viewModel.isThrottled) {
                let rating = await viewModel.generateOpinion()
                withAnimation(.spring(response: 0.4, dampingFraction: 0.58)) {
                    self.rating = rating
                }
            }
    }

    @ViewBuilder
    var content: some View {
        if rating == .loading {
            loader
                .transition(.blurReplace)
        } else {
            state
                .transition(.blurReplace)
        }
    }

    var loader: some View {
        HorStack {
            TimelineView(.animation(minimumInterval: 1.2)) { context in
                Circle()
                    .fill(rating.color)
                    .frame(width: 7, height: 7)
                    .shadow(
                        color: rating.color,
                        radius: CGFloat.random(in: 3.0...8.0),
                        x: CGFloat.random(in: -3.0...3.0),
                        y: CGFloat.random(in: -3.0...3.0)
                    )
                    .scaleEffect(CGFloat.random(in: 0.7...1.3))
                    .animation(.easeInOut(duration: 1.2), value: context.date)
            }

            Spacer()
        }
        .padding(.leading, 10)
        .padding(.top, 1.5)
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
