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

	@State private var webViewPresented = false

	let article: Article

	var body: some View {
        VerStack(alignment: .center) {
            CachedAsyncImage(article: article, viewModel: viewModel)
            otherContent
		}
		.toolbarRole(.editor)
		.toolbar {
			ToolbarItem(placement: .topBarLeading) {
                NavButton(
                    type: .back,
                    action: { dismiss() }
                )
			}

			ToolbarItem(placement: .principal) {
				DesignedText(text: Texts.Screen.Details.title())
					.font(.title)
			}
		}
		.navigationBarBackButtonHidden(true)
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
	}

	var buttons: some View {
        GlassEffectContainer {
            HorStack(spacing: Constants.padding / 2) {
                shareButton
                linkButton
                Spacer()
            }
        }
    }

	var shareButton: some View {
		ShareButton(
			data: ButtonMetaData(
				article: article,
				title: nil,
				iconName: "square.and.arrow.up"
            ),
            viewModel: viewModel
		)
	}

	var linkButton: some View {
		CustomButton(
			action: {
                viewModel.impactOccured(.light)
				webViewPresented.toggle()
			},
			title: nil,
			iconName: "link"
		)
		.modifier(
			FullScreenCoverModifier(
				viewModel: viewModel,
				webViewPresented: $webViewPresented,
				url: article.url.orEmpty
			)
		)
	}
}
