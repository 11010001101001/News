//
//  FavoritesButton.swift
//  News
//
//  Created by Ярослав Куприянов on 13.10.2025.
//

import Foundation
import SwiftUI
import ModelsKit
import DesignSystem

struct FavoritesButton: View {
    @Bindable var viewModel: DetailsViewModel
    let article: Article
    let isGlass: Bool
    let title: LocalizedStringResource?

    private var isFavorite: Bool {
        viewModel.checkIsFavorite(article)
    }

    var body: some View {
        CustomButton(
            action: {
                viewModel.impactOccured(.light)

                if isFavorite {
                    viewModel.favoriteTopics.removeAll(where: { $0 == article.favorite })
                } else {
                    viewModel.favoriteTopics.append(article.favorite)
                }
            },
            title: title,
            iconName: isFavorite ? SFSymbols.heartFill.rawValue : SFSymbols.heart.rawValue,
            isGlass: isGlass
        )
    }
}
