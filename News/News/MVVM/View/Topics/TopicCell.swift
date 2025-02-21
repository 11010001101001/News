//
//  TopicCell.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI

struct TopicCell: View {
	@ObservedObject private var viewModel: ViewModel
	private let article: Article

	init(viewModel: ViewModel, article: Article) {
		self.viewModel = viewModel
		self.article = article
	}

	var body: some View {
		Group {
			VerStack {
				DesignedText(text: article.title ?? .empty)
					.multilineTextAlignment(.leading)
					.padding(.bottom)
					.font(.headline)
					.foregroundStyle(Color.primary)
				DesignedText(text: article.publishedAt?.toReadableDate() ?? .empty)
					.font(.subheadline)
					.foregroundStyle(Color.secondary)
				DesignedText(text: article.source?.name ?? .empty)
					.font(.subheadline)
					.foregroundStyle(Color.secondary)
			}
			.padding(Constants.padding)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.card()
        .markAsReadOrHighlight(viewModel, article)
		.padding([.bottom, .horizontal], Constants.padding)
	}
}

extension TopicCell: Equatable {
	static func == (lhs: TopicCell, rhs: TopicCell) -> Bool {
		lhs.article.key == rhs.article.key
	}
}

#Preview {
	ScrollView {
		VerStack {
			Spacer().frame(height: 50)
			TopicCell(viewModel: ViewModel(),
					  article: Article(source: Source(id: UUID().uuidString,
													  name: "test"),
									   title: "Very long name that will be truncated to 30 characters or less if needed to fit the screen  ",
									   publishedAt: Date().makeTestDateString()))
			TopicCell(viewModel: ViewModel(),
					  article: Article(
						source: Source(id: UUID().uuidString,
									   name: "test"),
						// long text
						title: "Very ",
						publishedAt: Date().makeTestDateString())
			)
			TopicCell(viewModel: ViewModel(),
					  article: Article(source: Source(id: UUID().uuidString,
													  name: "test"),
									   title: "Very long name apple",
									   publishedAt: Date().makeTestDateString()))
		}
	}
	.background(.background)
}
