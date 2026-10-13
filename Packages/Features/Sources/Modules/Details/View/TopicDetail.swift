//
//  TopicDetail.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import DesignSystem
import LocalizationKit
import ModelsKit
import SwiftUI
import UIKit

struct TopicDetail: View {
    let viewModel: DetailsViewModel

    var body: some View {
        VerStack(spacing: Constants.padding) {
            CachedAsyncImage(viewModel: viewModel)
            description
        }
        .background {
            Color.gray.opacity(0.1).clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        }
        .padding(.bottom, Constants.padding)
        .padding(.horizontal, Constants.padding / 2)
    }
}

// MARK: - Content
extension TopicDetail {
    fileprivate var description: some View {
        VerStack(spacing: Constants.padding) {
            DesignedText(.init(stringLiteral: viewModel.description))
            buttons
        }
        .padding(.all, Constants.padding)
        .glassClearInteractive()
        .contextMenu { CopyContextMenuButton(action: { viewModel.copyDescription() }) }
    }

    fileprivate var buttons: some View {
        HorStack(spacing: Constants.detailsButtonsSpacing) {
            RatingBadge(viewModel: viewModel)
            Spacer()
            shareButton
            Divider()
            linkButton
            Divider()
            favoriteButton
        }
    }

    fileprivate var shareButton: some View {
        ShareButton(
            action: { viewModel.impactOccured(.light) },
            urlString: viewModel.url,
            isGlass: false
        )
    }

    fileprivate var linkButton: some View {
        LinkButton(viewModel: viewModel)
    }

    fileprivate var favoriteButton: some View {
        CustomButton(
            action: { viewModel.toggleFavorite() },
            title: nil,
            iconName: viewModel.favoriteIcon,
            isGlass: false
        )
    }
}
