//
//  EmptyFavoritesView.swift
//  News
//
//  Created by Ярослав Куприянов on 13.10.2025.
//

import SwiftUI
import Lottie

struct FavoritesEmptyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VerStack(alignment: .center) {
            Group {
                titleView
                image
                reloadButton
            }
            .padding(Constants.padding)
        }
        .glassCard()
    }
}

// MARK: - Content
private extension FavoritesEmptyView {
    var titleView: some View {
        DesignedText(text: Texts.Favorites.empty())
            .labelStyle(.titleOnly)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .font(.headline)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, CGFloat.sideInsets)
    }

    var image: some View {
        Image(uiImage: .favoritesEmptyCat)
            .resizable()
            .frame(width: 170, height: 170)
            .gloss(numberOfLayers: 1)
            .scaledToFill()
            .padding(.horizontal)
    }

    var reloadButton: some View {
        CustomButton(
            action: { dismiss() },
            title: Texts.Favorites.add()
        )
    }
}
