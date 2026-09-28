//
//  DetailsView.swift
//  News
//
//  Created by Ярослав Куприянов on 04.10.2025.
//

import SwiftUI
import ModelsKit

struct DetailsView: View {
    @State var viewModel: DetailsViewModel

    var body: some View {
        content
    }
}

extension DetailsView {
    fileprivate var content: some View {
        NavigationLink {
            TopicDetail(viewModel: viewModel)
        } label: {
            TopicCell(viewModel: viewModel, article: viewModel.article).equatable()
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
