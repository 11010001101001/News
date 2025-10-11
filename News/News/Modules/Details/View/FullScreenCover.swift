//
//  FullScreenCover.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 10.02.2025.
//

import SwiftUI

struct FullScreenCover<Content: View>: View {
	@Environment(\.dismiss) var dismiss

	let title: String
	let content: () -> Content

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
