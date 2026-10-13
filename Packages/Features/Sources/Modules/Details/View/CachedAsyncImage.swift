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
    let viewModel: DetailsViewModel

    @State private var cachedImage: Image?

    var body: some View {
        buildCachedAsyncImage()
            .onAppear {
                cachedImage = viewModel.getCachedImage()
                viewModel.markAsRead()
            }
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
                        .transition(.opacity)
                } else {
                    ShaderLoader(type: viewModel.loader)
                        .frame(maxWidth: .infinity)
                        .frame(height: 170)
                }
            }
        }
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
            .transition(.opacity.animation(.easeInOut(duration: 0.15)))
    }
}
