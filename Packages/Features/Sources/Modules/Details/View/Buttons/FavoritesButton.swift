//
//  FavoritesButton.swift
//  News
//
//  Created by Ярослав Куприянов on 13.10.2025.
//

import DesignSystem
import Foundation
import SwiftUI

struct FavoritesButton: View {
    @Bindable var viewModel: DetailsViewModel
    let isGlass: Bool
    let title: LocalizedStringResource?

    var body: some View {
        CustomButton(
            action: { viewModel.toggleFavorite() },
            title: title,
            iconName: viewModel.favoriteIcon,
            isGlass: isGlass
        )
    }
}
