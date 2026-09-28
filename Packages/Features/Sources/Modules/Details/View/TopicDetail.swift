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
    @State private var opinion = String.empty

    var body: some View {
        ScrollView {
            VerStack(spacing: Constants.padding) {
                CachedAsyncImage(viewModel: viewModel)
                description
                expertOpinion
                buttons
                Spacer()
            }
            .padding()
        }
        .toolbarRole(.editor)
        .toolbar {
            ToolbarItem(placement: .principal) {
                DesignedText(Strings.screenDetailsTitle)
                    .font(.title)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Content
extension TopicDetail {
    fileprivate var description: some View {
        DesignedText(.init(stringLiteral: viewModel.description))
            .padding(.all, Constants.padding)
            .glassClearInteractive()
            .contextMenu { contextMenu }
            .task {
                opinion = await viewModel.generateOpinion()
            }
    }

    fileprivate var expertOpinion: some View {
        ConditionalView(!opinion.isEmpty) {
            DesignedText(.init(stringLiteral: opinion))
                .padding(.all, Constants.padding)
                .glassClearInteractive()
        }
    }

    fileprivate var buttons: some View {
        GlassEffectContainer {
            VerStack(alignment: .leading, spacing: Constants.detailsButtonsSpacing) {
                HorStack(spacing: Constants.detailsButtonsSpacing) {
                    shareButton
                    linkButton
                    Spacer()
                }
                favoriteButton
            }
        }
    }

    fileprivate var shareButton: some View {
        ShareButton(
            viewModel: viewModel,
            isGlass: true
        )
    }

    fileprivate var linkButton: some View {
        LinkButton(viewModel: viewModel)
    }

    fileprivate var favoriteButton: some View {
        FavoritesButton(
            viewModel: viewModel,
            isGlass: true,
            title: nil
        )
    }

    fileprivate var contextMenu: some View {
        CopyContextMenuButton(viewModel: viewModel)
    }
}
