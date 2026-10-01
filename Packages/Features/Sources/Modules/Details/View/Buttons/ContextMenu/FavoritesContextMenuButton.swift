//
//  FavoritesContextMenuButton.swift
//  News
//
//  Created by Ярослав Куприянов on 13.10.2025.
//

import Foundation
import SwiftUI
import ModelsKit
import LocalizationKit
import DesignSystem

struct FavoritesContextMenuButton: View {
    @Bindable var viewModel: DetailsViewModel

    var body: some View {
        CustomButton(
            action: { viewModel.toggleFavorite() },
            title: viewModel.favoritesContextMenuTitle,
            iconName: viewModel.favoriteIcon,
            isGlass: false
        )
    }
}
