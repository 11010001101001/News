//
//  TopicCell.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI
import CoreKit
import ModelsKit
import DesignSystem
import LocalizationKit

struct TopicCell: View {
    @Bindable var viewModel: DetailsViewModel
    @State var imageWrapper: ContentWrapper?

    let article: Article

    var isRead: Bool {
        viewModel.checkIsRead(article.key)
    }

    var isShadowEnabled: Bool {
        ((article.title?.lowercased()).orEmpty).contains(viewModel.keyword.lowercased())
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
extension TopicCell {
    fileprivate var texts: some View {
        HorStack {
            VerStack {
                DesignedText(text: .init(stringLiteral: article.title.orEmpty))
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)
                    .font(.headline)
                    .foregroundStyle(Color.primary)
                DesignedText(text: .init(stringLiteral: (article.publishedAt?.toReadableDate()).orEmpty))
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
                DesignedText(text: .init(stringLiteral: (article.source?.name).orEmpty))
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
            }
            Spacer(minLength: CGFloat.leastNonzeroMagnitude)
        }
    }

    fileprivate var favoriteButton: some View {
        FavoritesButton(
            viewModel: viewModel,
            article: article,
            isGlass: false,
            title: nil
        )
    }

    @ViewBuilder
    fileprivate var contextMenu: some View {
        FavoritesContextMenuButton(
            viewModel: viewModel,
            article: article
        )

        ShareContextMenuButton(
            imageWrapper: $imageWrapper,
            data: ButtonMetaData(
                article: article,
                title: Strings.contextMenuShare,
                iconName: SFSymbols.squareAndArrowUp.rawValue
            ),
            viewModel: viewModel
        )

        MarkAsReadContextMenuButton(
            viewModel: viewModel,
            article: article
        )

        CopyContextMenuButton(
            text: article.title.orEmpty,
            viewModel: viewModel
        )
    }
}

extension TopicCell: Equatable {
    static func == (lhs: TopicCell, rhs: TopicCell) -> Bool {
        lhs.article.key == rhs.article.key
    }
}
