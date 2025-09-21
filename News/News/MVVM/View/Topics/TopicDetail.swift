//
//  Topic.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import SwiftUI
import UIKit

struct TopicDetail: View {
	@ObservedObject private var viewModel: ViewModel
	@Environment(\.dismiss) var dismiss

	@State private var webViewPresented = false

	private let article: Article

	init(viewModel: ViewModel, article: Article) {
		self.viewModel = viewModel
		self.article = article
	}

	var body: some View {
        VerStack(alignment: .center) {
            CachedAsyncImage(article: article, viewModel: viewModel)
            otherContent
		}
		.toolbarRole(.editor)
		.toolbar {
			ToolbarItem(placement: .topBarLeading) {
                NavButton(
                    viewModel: viewModel,
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

// MARK: - Private
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
            DesignedText(text: article.description.orEmpty(Texts.State.noDescription()))
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
			viewModel: viewModel,
			data: ButtonMetaData(
				article: article,
				title: nil,
				iconName: "square.and.arrow.up"
			)
		)
	}

	var linkButton: some View {
		CustomButton(
			viewModel: viewModel,
			action: {
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

#Preview {
	// swiftlint:disable line_length
	TopicDetail(viewModel: ViewModel(),
				article: Article(source: Source(id: UUID().uuidString,
												name: "Source"),
								 title: "Title",
								 description: "Very long description of the topic if you really want this for testing for example i dont know what to type more here but i guess it's enough Very long description of the topic if you really want this for testing for example i dont know what to type more here but i guess it's enough",
								 publishedAt: "Time"))
	// swiftlint:enable line_length
}
