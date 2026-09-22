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
    @Environment(\.dismiss) var dismiss

    let article: Article

    var body: some View {
        VerStack(alignment: .center) {
            CachedAsyncImage(article: article, viewModel: viewModel)
            otherContent
        }
        .toolbarRole(.editor)
        .toolbar {
            ToolbarItem(placement: .principal) {
                DesignedText(text: Strings.screenDetailsTitle)
                    .font(.title)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Content
extension TopicDetail {
    fileprivate var otherContent: some View {
        VerStack(alignment: .leading, spacing: Constants.padding) {
            description
            buttons
                .padding(.leading)
            Spacer()
        }
        .padding([.top, .horizontal])
        .frame(height: CGFloat.screenHeight / 2)
    }

    fileprivate var description: some View {
        Group {
            if let description = article.description, !description.isEmpty {
                DesignedText(text: .init(stringLiteral: description))
            } else {
                DesignedText(text: Strings.stateNoDescription)
            }
        }
        .padding(.all, Constants.padding)
        .glassEffect(
            .clear.interactive(), in: RoundedRectangle(cornerRadius: Constants.cornerRadius)
        )
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
