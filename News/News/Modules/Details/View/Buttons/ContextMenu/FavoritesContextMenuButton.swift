//
//  FavoritesButton.swift
//  News
//
//  Created by Ярослав Куприянов on 13.10.2025.
//

import Foundation
import SwiftUI

struct FavoritesContextMenuButton: View {
    @ObservedObject var viewModel: DetailsViewModel
    let article: Article

    private var isFavorite: Bool {
        viewModel.checkIsFavorite(article)
    }

    private var title: String {
        isFavorite ? Texts.ContextMenu.removeFromFavorites() : Texts.ContextMenu.addToFavorites()
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
            isGlass: false
        )
    }
}
