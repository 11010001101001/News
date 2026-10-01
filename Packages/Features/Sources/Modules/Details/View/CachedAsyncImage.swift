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
    @Bindable var viewModel: DetailsViewModel

    @State private var cachedImage: Image?

    var body: some View {
        buildCachedAsyncImage()
            .onAppear {
                cachedImage = viewModel.getCachedImage()
            }
            .onAppear { viewModel.markAsRead() }
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
            AsyncImage(url: URL(string: viewModel.imageUrl)) { phase in
                if let image = phase.image {
                    image
                        .toFrame()
                        .onAppear { viewModel.cache(image) }
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
