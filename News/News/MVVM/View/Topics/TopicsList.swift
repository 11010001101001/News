//
//  TopicsList.swift
//  News
//
//  Created by Ярослав Куприянов on 29.03.2024.
//

import SwiftUI

struct TopicsList: View {
	@ObservedObject var viewModel: ViewModel
	@State private var enderOpacity: CGFloat = .zero

	var body: some View {
		ScrollViewReader { proxy in
			ZStack {
				buildTopicsList(proxy: proxy)

				Loader(
					loaderName: viewModel.loader,
					shadowColor: viewModel.loaderShadowColor
				)
				.opacity($viewModel.loadingSucceed.wrappedValue ? .zero : 1.0)
				.id(viewModel.id)

				ErrorView(
					viewModel: viewModel,
					title: $viewModel.failureReason.wrappedValue,
					action: { viewModel.loadNews() }
				)
				.padding(.horizontal, CGFloat.sideInsets)
				.opacity($viewModel.loadingFailed.wrappedValue ? 1.0 : .zero)
			}
		}
	}
}

// MARK: - Private
private extension TopicsList {
	func buildTopicsList(proxy: ScrollViewProxy) -> some View {
		CustomScrollView(
			content: {
				VerStack {
					buildTopic()
					buildScrollEnder()
				}
				.padding(.top, Constants.padding)
			},
			viewModel: viewModel
		)
		.opacity($viewModel.loadingSucceed.wrappedValue ? 1.0 : .zero)
	}

	func buildTopic() -> some View {
		ForEach($viewModel.newsArray) { $article in
			NavigationLink {
				TopicDetail(viewModel: viewModel, article: article)
			} label: {
				TopicCell(viewModel: viewModel, article: article).equatable()
			}
			.scrollTransition(
				topLeading: .identity,
				bottomTrailing: .interactive,
				transition: { content, phase in
					content
						.hueRotation(.degrees(360 * phase.value))
						.scaleEffect(phase.isIdentity ? 1 : 0.95)
						.blur(radius: phase.isIdentity ? 0 : 1)
				}
			)
		}
	}

	func buildScrollEnder() -> some View {
		HorStack {
			Spacer()
			Color.red
				.clipShape(.rect(cornerRadius: Constants.cornerRadius))
				.gloss(color: .red)
				.frame(width: 150, height: 1)
				.opacity(enderOpacity)
				.padding(.top, -Constants.padding)
				.onAppear {
					withAnimation(.bouncy(duration: 2.0).repeatForever(autoreverses: true)) {
						enderOpacity = 1
					}
				}
			Spacer()
		}
	}
}

#Preview {
	TopicsList(viewModel: ViewModel())
}
