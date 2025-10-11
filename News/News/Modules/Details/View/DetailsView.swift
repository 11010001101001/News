//
//  MainView.swift
//  News
//
//  Created by Ярослав Куприянов on 04.10.2025.
//

import SwiftUI

struct DetailsView: View {
    @StateObject var viewModel: DetailsViewModel

    let article: Article

    var body: some View {
        content
    }
}

private extension DetailsView {
    var content: some View {
        NavigationLink {
            TopicDetail(viewModel: viewModel, article: article)
        } label: {
            TopicCell(viewModel: viewModel, article: article).equatable()
        }
        .scrollTransition(
            topLeading: .identity,
            bottomTrailing: .interactive,
            transition: { content, phase in
                content
                    .hueRotation(.degrees(360 * phase.value))
                    .scaleEffect(phase.isIdentity ? 1 : 0.95)
                    .blur(radius: phase.isIdentity ? 0 : 1)
            }
        )
    }
}
