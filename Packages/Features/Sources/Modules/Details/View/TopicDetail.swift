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
    @Bindable var viewModel: DetailsViewModel
    @State private var rating = Rating.loading

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
        .animation(.spring(response: 0.4, dampingFraction: 0.58), value: rating)
        .task(id: viewModel.isThrottled) {
            self.rating = await viewModel.generateOpinion()
        }
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
        .contextMenu { CopyContextMenuButton(viewModel: viewModel) }
    }

    fileprivate var buttons: some View {
        HorStack(spacing: Constants.detailsButtonsSpacing) {
            RatingBadge(rating: rating)
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
            viewModel: viewModel,
            isGlass: false
        )
    }

    fileprivate var linkButton: some View {
        LinkButton(viewModel: viewModel)
    }

    fileprivate var favoriteButton: some View {
        FavoritesButton(
            viewModel: viewModel,
            isGlass: false,
            title: nil
        )
    }
}
