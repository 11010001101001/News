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
import LocalizationKit

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
            .task {
                cachedImage = await viewModel.getCachedImage(key: key)
            }
            .onAppear { viewModel.markAsRead(article) }
    }
}

// MARK: Content
extension CachedAsyncImage {
    @ViewBuilder
    private func buildCachedAsyncImage() -> some View {
        if let cachedImage {
            cachedImage
                .toFrame()
        } else {
            AsyncImage(url: URL(string: url)) { phase in
                if let image = phase.image {
                    image
                        .toFrame()
                        .onAppear { cache(image) }
                } else if phase.error != nil {
                    ErrorView(title: Strings.errorsImageLoadingError, action: nil)
                } else {
                    loader
                }
            }
        }
    }

    fileprivate var loader: some View {
        Loader(
            loaderName: viewModel.loader,
            shadowColor: viewModel.loaderShadowColor
        )
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
            .aspectRatio(contentMode: .fit)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous))
            .glassClearInteractive()
    }
}
