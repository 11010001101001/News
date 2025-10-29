//
//  CachedAsyncImage.swift
//  News
//
//  Created by Ярослав Куприянов on 04.07.2024.
//

import SwiftUI
import Foundation

struct CachedAsyncImage: View {
    let article: Article

    @ObservedObject var viewModel: DetailsViewModel

    private var url: String {
        article.urlToImage.orEmpty
    }

    private var key: AnyObject {
        url as AnyObject
    }

    private var cachedImage: Image? {
        viewModel.getCachedImage(key: key)
    }

    var body: some View {
        buildCachedAsyncImage()
            .padding()
            .onAppear { viewModel.markAsRead(article.key) }
    }
}

// MARK: Content
private extension CachedAsyncImage {
    @ViewBuilder
    private func buildCachedAsyncImage() -> some View {
        if let cachedImage {
            cachedImage
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
                let error = String(phase.error?.localizedDescription.prefix(40) ?? "") + "..."
                buildError(title: error)
            } else {
                loader
            }
        }
    }

    var loader: some View {
        Loader(
            loaderName: viewModel.loader,
            shadowColor: viewModel.loaderShadowColor
        )
        .frame(height: Constants.imageHeight)
    }

    func buildError(title: String) -> some View {
        ErrorView(title: title, action: nil)
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
