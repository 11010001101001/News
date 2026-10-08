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
        FavoritesButton(
            viewModel: viewModel,
            isGlass: false,
            title: nil
        )
    }

    @ViewBuilder
    fileprivate var contextMenu: some View {
        FavoritesContextMenuButton(viewModel: viewModel)
        ShareContextMenuButton(imageWrapper: $imageWrapper, viewModel: viewModel)
        MarkAsReadContextMenuButton(viewModel: viewModel)
        CopyContextMenuButton(viewModel: viewModel)
    }
}
