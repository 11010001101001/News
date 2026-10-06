//
//  DetailsView.swift
//  News
//
//  Created by Ярослав Куприянов on 04.10.2025.
//

import DesignSystem
import ModelsKit
import SwiftUI

struct DetailsView: View {
    @State var viewModel: DetailsViewModel
    @State private var isCollapsed = true

    var body: some View {
        content
            .scrollTransition(
                topLeading: .identity,
                bottomTrailing: .interactive,
                transition: { content, phase in
                    content
                        .blur(radius: phase.isIdentity ? 0 : 1)
                }
            )
            .onTapGesture {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                    isCollapsed.toggle()
                }
            }
    }
}

extension DetailsView {
    @ViewBuilder
    fileprivate var content: some View {
        if isCollapsed {
            TopicCell(viewModel: viewModel)
                .transition(.opacity.combined(with: .scale(0.95)))
        } else {
            TopicDetail(viewModel: viewModel)
                .transition(.opacity.combined(with: .scale(0.95)))
        }
    }
}
