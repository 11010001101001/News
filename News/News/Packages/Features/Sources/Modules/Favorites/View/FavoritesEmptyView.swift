//
//  EmptyFavoritesView.swift
//  News
//
//  Created by Ярослав Куприянов on 13.10.2025.
//

import Lottie
import SwiftUI
import DesignSystem
import ModelsKit
import LocalizationKit

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
extension FavoritesEmptyView {
    fileprivate var titleView: some View {
        DesignedText(text: Strings.favoritesEmpty)
            .labelStyle(.titleOnly)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .font(.headline)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, CGFloat.sideInsets)
    }

    fileprivate var image: some View {
        Images.favoritesEmptyCat
            .resizable()
            .frame(width: 170, height: 170)
            .gloss(numberOfLayers: 1)
            .scaledToFill()
            .padding(.horizontal)
    }

    fileprivate var reloadButton: some View {
        CustomButton(
            action: { dismiss() },
            title: Strings.favoritesAdd
        )
    }
}
