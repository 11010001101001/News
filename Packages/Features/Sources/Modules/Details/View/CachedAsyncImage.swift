//
//  CachedAsyncImage.swift
//  News
//
//  Created by Ярослав Куприянов on 04.07.2024.
//

import Foundation
import SwiftUI
import ModelsKit
import DesignSystem
import CoreKit

struct CachedAsyncImage: View {
    let article: Article

    @Bindable var viewModel: DetailsViewModel

    @State private var cachedImage: Image?

    private var url: String {
        article.urlToImage.orEmpty
    }

    private var key: AnyObject & Sendable {
        url as AnyObject & Sendable
    }

    var body: some View {
        buildCachedAsyncImage()
            .padding()
            .task {
                cachedImage = await viewModel.getCachedImage(key: key)
            }
            .onAppear { viewModel.markAsRead(article.key) }
    }
}

// MARK: Content
extension CachedAsyncImage {
    @ViewBuilder
    private func buildCachedAsyncImage() -> some View {
        if let cachedImage {
            cachedImage
                .toFrame()
                .glassCard()
        } else {
            asyncImage
        }
    }

    fileprivate var asyncImage: some View {
        AsyncImage(url: URL(string: url)) { phase in
            if let image = phase.image {
                image
                    .toFrame()
                    .onAppear { cache(image) }
            } else if phase.error != nil {
                let error = String(phase.error?.localizedDescription.prefix(40) ?? "") + "..."
                buildError(title: error)
            } else {
                loader
            }
        }
    }

    fileprivate var loader: some View {
        Loader(
            loaderName: viewModel.loader,
            shadowColor: viewModel.loaderShadowColor
        )
        .frame(height: Constants.imageHeight)
    }

    fileprivate func buildError(title: String) -> some View {
        ErrorView(title: .init(stringLiteral: title), action: nil)
            .frame(height: Constants.imageHeight)
    }
}

// MARK: Cache
extension CachedAsyncImage {
    fileprivate func cache(_ image: Image) {
        let object = CachedImage(image: image)
        viewModel.cache(object: object, key: key)
    }
}

extension Image {
    @MainActor fileprivate func toFrame() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(
                width: CGFloat.screenWidth - 32,
                height: Constants.imageHeight,
                alignment: .center
            )
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous))
            .glassCard()
    }
}
