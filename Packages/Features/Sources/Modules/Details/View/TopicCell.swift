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

    var body: some View {
        Group {
            ZStack(alignment: .bottomTrailing) {
                texts
                favoriteButton
            }
            .padding(Constants.padding)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .markAsReadOrHighlight(isRead: viewModel.isRead, isShadowEnabled: viewModel.isShadowEnabled)
        .glassClearInteractive()
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
                DesignedText(.init(stringLiteral: viewModel.title))
                    .multilineTextAlignment(.leading)
                    .padding(.bottom)
                    .font(.headline)
                    .foregroundStyle(Color.primary)
                DesignedText(.init(stringLiteral: viewModel.publishedAt))
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
                DesignedText(.init(stringLiteral: viewModel.sourceName))
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
            }
            Spacer(minLength: CGFloat.leastNonzeroMagnitude)
        }
    }

    fileprivate var favoriteButton: some View {
        CustomButton(
            action: { viewModel.toggleFavorite() },
            title: nil,
            iconName: viewModel.favoriteIcon,
            isGlass: false
        )
    }

    @ViewBuilder
    fileprivate var contextMenu: some View {
        FavoritesContextMenuButton(
            action: { viewModel.toggleFavorite() },
            title: viewModel.favoritesContextMenuTitle,
            iconName: viewModel.favoriteIcon
        )
        ShareContextMenuButton(
            imageWrapper: $imageWrapper,
            action: { viewModel.impactOccured(.light) },
            urlString: viewModel.url
        )
        MarkAsReadContextMenuButton(
            action: { viewModel.markAsReadOrUnread() },
            title: viewModel.isReadTitle,
            iconName: viewModel.isReadIcon
        )
        CopyContextMenuButton(action: { viewModel.copyDescription() })
    }
}
