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
        ((article.title?.lowercased()).orEmpty).contains("apple")
    }

	var body: some View {
		Group {
            ZStack(alignment: .bottomTrailing) {
                texts
                favoriteIcon
            }
			.padding(Constants.padding)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
        .glassCard()
        .markAsReadOrHighlight(isRead: isRead, isShadowEnabled: isShadowEnabled)
		.padding([.bottom, .horizontal], Constants.padding)
	}
}

// MARK: - Content
private extension TopicCell {
    var texts: some View {
        VerStack {
            DesignedText(text: article.title.orEmpty)
                .multilineTextAlignment(.leading)
                .padding(.bottom)
                .font(.headline)
                .foregroundStyle(Color.primary)
            DesignedText(text: (article.publishedAt?.toReadableDate()).orEmpty)
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
            DesignedText(text: (article.source?.name).orEmpty)
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
        }
    }

    @ViewBuilder
    var favoriteIcon: some View {
        let isFavorite = viewModel.checkIsFavorite(article)

        Button {
            if isFavorite {
                viewModel.favoriteTopics.removeAll(where: { $0 == article.favorite })
            } else {
                viewModel.favoriteTopics.append(article.favorite)
            }
        } label: {
            isFavorite ? SFSymbols.starFill.image : SFSymbols.star.image
        }
    }
}

extension TopicCell: Equatable {
	static func == (lhs: TopicCell, rhs: TopicCell) -> Bool {
		lhs.article.key == rhs.article.key
	}
}
