//
//  TopicCell.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI

struct TopicCell: View {
    @ObservedObject var viewModel: DetailsViewModel
    @State var imageWrapper: ContentWrapper?

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
                favoriteButton
            }
            .padding(Constants.padding)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassCard()
        .markAsReadOrHighlight(isRead: isRead, isShadowEnabled: isShadowEnabled)
        .padding([.bottom, .horizontal], Constants.padding)
        .contentShape(.rect)
        .contextMenu { contextMenu }
        .sheet(
            item: $imageWrapper,
            content: { content in
                ActivityViewController(contentWrapper: content)
                    .presentationDetents([.medium])
            }
        )
    }
}

// MARK: - Content
private extension TopicCell {
    var texts: some View {
        HorStack {
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
            Spacer(minLength: CGFloat.leastNonzeroMagnitude)
        }
    }

    var favoriteButton: some View {
        FavoritesButton(
            viewModel: viewModel,
            article: article,
            isGlass: false,
            title: nil
        )
    }

    @ViewBuilder
    var contextMenu: some View {
        FavoritesContextMenuButton(
            viewModel: viewModel,
            article: article
        )

        ShareContextMenuButton(
            imageWrapper: $imageWrapper,
            data: ButtonMetaData(
                article: article,
                title: Texts.ContextMenu.share(),
                iconName: SFSymbols.squareAndArrowUp.rawValue
            ),
            viewModel: viewModel
        )

        MarkAsReadContextMenuButton(
            viewModel: viewModel,
            article: article
        )

        CopyContextMenuButton(text: article.title.orEmpty)
    }
}

extension TopicCell: Equatable {
    static func == (lhs: TopicCell, rhs: TopicCell) -> Bool {
        lhs.article.key == rhs.article.key
    }
}
