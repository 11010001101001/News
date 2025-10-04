//
//  TopicCell.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI

struct TopicCell: View {
	@ObservedObject var viewModel: DetailsViewModel
	let article: Article

    var isRead: Bool {
        viewModel.checkIsRead(article.key)
    }

    var isShadowEnabled: Bool {
        (article.title?.lowercased() ?? .empty).contains("apple")
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
        .glassCard()
        .markAsReadOrHighlight(isRead: isRead, isShadowEnabled: isShadowEnabled)
		.padding([.bottom, .horizontal], Constants.padding)
	}
}

extension TopicCell: Equatable {
	static func == (lhs: TopicCell, rhs: TopicCell) -> Bool {
		lhs.article.key == rhs.article.key
	}
}
