//
//  TopicDetail.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI
import UIKit
import ModelsKit
import DesignSystem
import LocalizationKit

struct TopicDetail: View {
    @Bindable var viewModel: DetailsViewModel

    let article: Article

    var body: some View {
        ScrollView {
            VerStack(spacing: Constants.padding) {
                CachedAsyncImage(article: article, viewModel: viewModel)
                description
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
        Group {
            if let description = article.description, !description.isEmpty {
                DesignedText(.init(stringLiteral: description))
            } else {
                DesignedText(Strings.stateNoDescription)
            }
        }
        .padding(.all, Constants.padding)
        .glassClearInteractive()
        .contextMenu { contextMenu }
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
            data: ButtonMetaData(
                article: article,
                title: nil,
                iconName: SFSymbols.squareAndArrowUp.rawValue
            ),
            viewModel: viewModel,
            isGlass: true
        )
    }

    fileprivate var linkButton: some View {
        LinkButton(
            viewModel: viewModel,
            article: article
        )
    }

    fileprivate var favoriteButton: some View {
        FavoritesButton(
            viewModel: viewModel,
            article: article,
            isGlass: true,
            title: nil
        )
    }

    fileprivate var contextMenu: some View {
        CopyContextMenuButton(
            text: article.description.or(String(localized: Strings.stateNoDescription)),
            viewModel: viewModel
        )
    }
}
