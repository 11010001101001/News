//
//  CategoryCard.swift
//  Features
//
//  Created by Slava on 08.10.2026.
//

import Foundation
import SwiftUI
import DesignSystem
import ModelsKit

struct CategoryCard: View {
    let viewModel: SettingsViewModel
    let category: NewsCategory

    var body: some View {
        VerStack(alignment: .center, spacing: 8) {
            ImageProvider
                .image(category.rawValue)
                .font(.title2)

            DesignedText(category.displayName)
                .font(.subheadline)
                .fontWeight(.bold)
        }
        .frame(height: 90)
        .frame(maxWidth: .infinity)
        .markIsSelected(viewModel.category == category.rawValue)
        .glassClearInteractive()
        .applyOrNotSettingsModifier(
            isEnabled: viewModel.category == category.rawValue
        ) {
            viewModel.applySettings(category.rawValue)
        }
    }
}
