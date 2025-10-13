//
//  FavoritesButton.swift
//  News
//
//  Created by Ярослав Куприянов on 13.10.2025.
//

import Foundation
import SwiftUI

struct FavoritesButton: View {
    @ObservedObject var viewModel: DetailsViewModel
    let article: Article
    let isGlass: Bool

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
            title: nil,
            iconName: isFavorite ? SFSymbols.starFill.rawValue : SFSymbols.star.rawValue,
            isGlass: isGlass
        )
    }
}
