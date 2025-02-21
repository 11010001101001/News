//
//  CachedAsyncImage.swift
//  News
//
//  Created by Ярослав Куприянов on 04.07.2024.
//

import SwiftUI

struct CachedAsyncImage: View {
	private let article: Article

	@ObservedObject private var viewModel: ViewModel

	@State private var origin: CGPoint = .zero
	@State private var counter: Int = 0
	@State private var rotating = false
	@State private var scale: CGFloat = .zero
	@State private var coords = CGFloat.randomCoordinates

	private var url: String {
		article.urlToImage ?? .empty
	}

	private var key: AnyObject {
		url as AnyObject
	}

	private var cachedImage: Image? {
		viewModel.getCachedImage(key: key)
	}

	init(article: Article, rotating: Bool = false, viewModel: ViewModel) {
		self.article = article
		self.rotating = rotating
		self.viewModel = viewModel
	}

	var body: some View {
		buildCachedAsyncImage()
			.padding([.vertical, .horizontal])
			.onAppear { viewModel.markAsRead(article.key) }
	}
}

// MARK: Content
extension CachedAsyncImage {
	@ViewBuilder
	private func buildCachedAsyncImage() -> some View {
		if let cachedImage {
			cachedImage
				.makeRounded(height: Constants.imageHeight)
				.applyRotationAndScale($rotating, $scale, coords)
				.modifier(RippleEffect(at: origin, trigger: counter))
				.onTapGesture { location in
					origin = location
					counter += 1
				}
		} else {
			asyncImage
		}
	}

	var asyncImage: some View {
		AsyncImage(url: URL(string: url)) { phase in
			if let image = phase.image {
				image
					.resizable()
					.onAppear { cache(image) }
			} else if phase.error != nil {
				error
			} else {
				loader
			}
		}
	}

	var error: some View {
		ErrorView(viewModel: viewModel, title: Errors.imageLoadingError, action: nil)
			.applyRotationAndScale($rotating, $scale, coords)
			.frame(height: Constants.imageHeight)
	}

	var loader: some View {
		Loader(
			loaderName: viewModel.loader,
			shadowColor: viewModel.loaderShadowColor
		)
		.frame(height: Constants.imageHeight)
	}
}

// MARK: Cache
private extension CachedAsyncImage {
	func cache(_ image: Image) {
		let object = CachedImage(image: image)
		viewModel.cache(object: object, key: key)
	}
}

// MARK: Common view extension
private extension View {
	// swiftlint:disable large_tuple
	func applyRotationAndScale(
		_ rotating: Binding<Bool>,
		_ scale: Binding<CGFloat>,
		_ coords: (x: CGFloat, y: CGFloat, z: CGFloat)
	) -> some View {
		self
			.rotation3DEffect(
				Angle(degrees: rotating.wrappedValue ? -4 : 4),
				axis: coords,
				anchor: .center
			)
			.scaleEffect(scale.wrappedValue)
			.onAppear {
				withAnimation(.smooth(duration: 30).repeatForever(autoreverses: true)) {
					rotating.wrappedValue.toggle()
				}
				withAnimation(.smooth(duration: 0.2, extraBounce: 0.3)) {
					scale.wrappedValue = 1.0
				}
			}
	}
	// swiftlint:enable large_tuple
}
