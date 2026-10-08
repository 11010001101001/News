//
//  LoadersCarusel.swift
//  Features
//
//  Created by Slava on 08.10.2026.
//

import DesignSystem
import ModelsKit
import SwiftUI

struct LoadersCarusel: View {
    let viewModel: SettingsViewModel

    @State private var scrolledID: LoaderConfiguration? = .rocket
    @State private var activeColor: Color = LoaderConfiguration.rocket.shadowColor

    var body: some View {
        GeometryReader { proxy in
            let cardSize = CGSize(width: proxy.size.width / 2, height: proxy.size.height / 2)
            let sidePadding = (proxy.size.width - cardSize.width) / 2

            ScrollView(.horizontal) {
                VerStack {
                    Spacer()
                    HorStack(spacing: Constants.padding) {
                        ForEach(LoaderConfiguration.allCases) { loader in
                            LoaderCard(viewModel: viewModel, loader: loader)
                                .frame(width: cardSize.width, height: cardSize.height)
                        }
                        .scrollTransition(.interactive) { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1.2 : 0.85)
                                .opacity(phase.isIdentity ? 1.0 : 0.7)
                                .blur(radius: abs(phase.value) * 3)
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.horizontal, sidePadding)
                    Spacer()
                }
            }
            .background(
                Circle()
                    .fill(activeColor)
                    .frame(width: 250, height: 250)
                    .blur(radius: 60)
                    .opacity(0.35)
            )
            .scrollPosition(id: $scrolledID)
            .sensoryFeedback(.selection, trigger: scrolledID)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .onChange(of: scrolledID) {
                guard let scrolledID,
                    let currentLoader = LoaderConfiguration.allCases.first(where: {
                        $0.id == scrolledID
                    })
                else { return }

                withAnimation(.snappy(duration: 0.3)) {
                    activeColor = currentLoader.shadowColor
                }
            }
        }
    }
}
