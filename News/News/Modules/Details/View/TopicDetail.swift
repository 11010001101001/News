//
//  Topic.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI
import UIKit

struct TopicDetail: View {
	@ObservedObject var viewModel: DetailsViewModel
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
				DesignedText(text: Texts.Screen.Details.title())
					.font(.title)
			}
		}
		.navigationBarTitleDisplayMode(.inline)
	}
}

// MARK: - Content
private extension TopicDetail {
	var otherContent: some View {
        VerStack(alignment: .leading, spacing: Constants.padding) {
            description
            buttons
                .padding(.leading)
            Spacer()
        }
        .padding([.top, .horizontal])
        .frame(height: CGFloat.screenHeight / 2)
	}

	var description: some View {
        Group {
            DesignedText(text: article.description.or(Texts.State.noDescription()))
                .padding(.all, Constants.padding)
        }
        .glassEffect(.clear.interactive(), in: RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .contextMenu { contextMenu }
	}

	var buttons: some View {
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

	var shareButton: some View {
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

	var linkButton: some View {
        LinkButton(
            viewModel: viewModel,
            article: article
        )
	}

    var favoriteButton: some View {
        FavoritesButton(
            viewModel: viewModel,
            article: article,
            isGlass: true,
            title: nil
        )
    }

    var contextMenu: some View {
        CopyContextMenuButton(
            text: article.description.or(Texts.State.noDescription()),
            viewModel: viewModel
        )
    }
}
