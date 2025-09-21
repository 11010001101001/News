//
//  FullScreenCover.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 10.02.2025.
//

import SwiftUI

struct FullScreenCover<Content: View>: View {
	@Environment(\.dismiss) var dismiss

    private let viewModel: ViewModel
	private let title: String
	private let content: () -> Content

	init(
        viewModel: ViewModel,
        title: String,
        content: @escaping () -> Content
    ) {
        self.viewModel = viewModel
		self.title = title
		self.content = content
	}

	var body: some View {
		NavigationStack {
			content()
				.ignoresSafeArea(.container, edges: .bottom)
				.toolbar {
					ToolbarItem(placement: .principal) {
						DesignedText(text: title)
							.font(.title)
					}

					ToolbarItem(placement: .topBarTrailing) {
                        NavButton(
                            viewModel: viewModel,
                            type: .close,
                            action: { dismiss() }
                        )
					}
				}
				.navigationBarTitleDisplayMode(.inline)
				.background(ignoresSafeAreaEdges: .all)
		}
	}
}

#Preview {
	FullScreenCover(
        viewModel: ViewModel(),
        title: "More"
    ) {
		Color.green
	}
}
